#!/usr/bin/env python3
"""Sichere Validierung und Verwaltung des markierten Xebico-Hosts-Blocks."""

from __future__ import annotations

import argparse
import errno
import os
import stat
import sys
import tempfile
from pathlib import Path

INTERNAL_DIR = Path(__file__).resolve().parent
sys.path.insert(0, str(INTERNAL_DIR))

from pilotlib import PilotValidationError, validate_hosts_line

BEGIN = "# BEGIN LABFORGE XEBICO"
END = "# END LABFORGE XEBICO"
MAX_STAGING_BYTES = 256
MAX_HOSTS_BYTES = 1024 * 1024


def read_nofollow(
    path: Path,
    *,
    max_bytes: int,
    expected_uid: int | None = None,
) -> tuple[bytes, os.stat_result]:
    flags = os.O_RDONLY
    if hasattr(os, "O_NOFOLLOW"):
        flags |= os.O_NOFOLLOW
    try:
        fd = os.open(path, flags)
    except FileNotFoundError as exc:
        raise PilotValidationError(f"Datei fehlt: {path}") from exc
    except OSError as exc:
        raise PilotValidationError(f"Datei kann nicht sicher geöffnet werden: {path}: {exc}") from exc

    try:
        info = os.fstat(fd)
        if not stat.S_ISREG(info.st_mode):
            raise PilotValidationError(f"Keine reguläre Datei: {path}")
        if expected_uid is not None and info.st_uid != expected_uid:
            raise PilotValidationError(
                f"Falscher Besitzer für {path}: UID {info.st_uid}, erwartet {expected_uid}"
            )
        if info.st_size > max_bytes:
            raise PilotValidationError(
                f"Datei ist zu groß: {path} ({info.st_size} Byte)"
            )
        data = b""
        while len(data) <= max_bytes:
            chunk = os.read(fd, min(4096, max_bytes + 1 - len(data)))
            if not chunk:
                break
            data += chunk
        if len(data) > max_bytes:
            raise PilotValidationError(f"Datei überschreitet {max_bytes} Byte: {path}")
        return data, info
    finally:
        os.close(fd)


def parse_staging(path: Path, expected_uid: int) -> tuple[str, str]:
    raw, _info = read_nofollow(
        path,
        max_bytes=MAX_STAGING_BYTES,
        expected_uid=expected_uid,
    )
    try:
        text = raw.decode("utf-8")
    except UnicodeDecodeError as exc:
        raise PilotValidationError("Registerdatei ist nicht gültiges UTF-8.") from exc
    return validate_hosts_line(text)


def build_hosts(original: str, address: str) -> str:
    begin_count = original.count(BEGIN)
    end_count = original.count(END)
    if begin_count != end_count or begin_count > 1:
        raise PilotValidationError(
            "Der verwaltete Xebico-Block ist beschädigt oder mehrfach vorhanden."
        )

    block = f"{BEGIN}\n{address} xebico\n{END}\n"

    if begin_count == 0:
        if original and not original.endswith("\n"):
            original += "\n"
        return original + block

    start = original.index(BEGIN)
    end_start = original.index(END, start)
    end_pos = end_start + len(END)
    if end_pos < len(original) and original[end_pos] == "\n":
        end_pos += 1

    if end_start < start:
        raise PilotValidationError("Reihenfolge der Blockmarkierungen ist ungültig.")

    return original[:start] + block + original[end_pos:]


def verify_block(text: str, address: str) -> None:
    expected = f"{BEGIN}\n{address} xebico\n{END}"
    if text.count(BEGIN) != 1 or text.count(END) != 1:
        raise PilotValidationError("Nach dem Schreiben existiert nicht genau ein Xebico-Block.")
    start = text.index(BEGIN)
    end = text.index(END, start) + len(END)
    if text[start:end] != expected:
        raise PilotValidationError("Der geschriebene Xebico-Block entspricht nicht dem Sollzustand.")


def write_hosts_safely(
    path: Path,
    original: bytes,
    original_info: os.stat_result,
    updated: bytes,
    allow_inplace_fallback: bool,
) -> None:
    parent = path.parent
    fd, temp_name = tempfile.mkstemp(prefix=".labforge-hosts.", dir=parent)
    temp_path = Path(temp_name)
    try:
        os.fchmod(fd, stat.S_IMODE(original_info.st_mode))
        try:
            os.fchown(fd, original_info.st_uid, original_info.st_gid)
        except PermissionError:
            if os.geteuid() == 0:
                raise
        os.write(fd, updated)
        os.fsync(fd)
        os.close(fd)
        fd = -1
        try:
            os.replace(temp_path, path)
            return
        except OSError as exc:
            if not allow_inplace_fallback or exc.errno not in {
                errno.EBUSY,
                errno.EXDEV,
                errno.EPERM,
                errno.EACCES,
            }:
                raise

        flags = os.O_WRONLY
        if hasattr(os, "O_NOFOLLOW"):
            flags |= os.O_NOFOLLOW
        target_fd = os.open(path, flags)
        try:
            current_info = os.fstat(target_fd)
            if (
                current_info.st_dev != original_info.st_dev
                or current_info.st_ino != original_info.st_ino
            ):
                raise PilotValidationError(
                    "Hosts-Datei wurde während der Anwendung ausgetauscht."
                )
            try:
                os.ftruncate(target_fd, 0)
                os.write(target_fd, updated)
                os.fsync(target_fd)
            except Exception:
                os.ftruncate(target_fd, 0)
                os.write(target_fd, original)
                os.fsync(target_fd)
                raise
        finally:
            os.close(target_fd)
    finally:
        if fd >= 0:
            os.close(fd)
        try:
            temp_path.unlink()
        except FileNotFoundError:
            pass


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("action", choices=("validate", "apply"))
    parser.add_argument("--staging", required=True, type=Path)
    parser.add_argument("--expected-owner-uid", required=True, type=int)
    parser.add_argument("--hosts", type=Path)
    parser.add_argument("--allow-inplace-fallback", action="store_true")
    args = parser.parse_args()

    try:
        address, name = parse_staging(args.staging, args.expected_owner_uid)
        if args.action == "validate":
            print("Registereintrag gültig.")
            print(f"Name:     {name}")
            print(f"Adresse:  {address}")
            return 0

        if args.hosts is None:
            raise PilotValidationError("--hosts ist für apply erforderlich.")

        original_raw, original_info = read_nofollow(
            args.hosts,
            max_bytes=MAX_HOSTS_BYTES,
        )
        try:
            original_text = original_raw.decode("utf-8")
        except UnicodeDecodeError as exc:
            raise PilotValidationError("Hosts-Datei ist nicht gültiges UTF-8.") from exc

        updated_text = build_hosts(original_text, address)
        verify_block(updated_text, address)
        updated_raw = updated_text.encode("utf-8")

        write_hosts_safely(
            args.hosts,
            original_raw,
            original_info,
            updated_raw,
            args.allow_inplace_fallback,
        )

        check_raw, _ = read_nofollow(args.hosts, max_bytes=MAX_HOSTS_BYTES)
        check_text = check_raw.decode("utf-8")
        verify_block(check_text, address)

        print("Registereintrag angewendet.")
        print(f"{address}    xebico")
        return 0
    except (PilotValidationError, OSError) as exc:
        print(f"Register nicht gültig: {exc}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
