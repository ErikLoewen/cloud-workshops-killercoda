# Interaktive Netzwerkarchitektur im Text

Wechsle einmal in das vorbereitete Arbeitskonto:

`su - telegrafist`{{exec}}

`cd ~/nachtstation`{{exec}}

Dieser Schritt prüft getrennt, was der Killercoda-Markdownrenderer mit
**HTML**, **CSS**, **JavaScript** und einem eingebetteten `iframe` macht.

Die offizielle Beispielsammlung bestätigt einfache HTML-Elemente wie
`<details>`. Für beliebiges CSS, JavaScript und `iframe` gibt es keine
zugesicherte Plattformfunktion. Deshalb kann jede Probe als
**unterstützt** oder **blockiert** dokumentiert werden.

## A · Inline-HTML, CSS und JavaScript

<style>
#kc-inline-netz {
  border: 2px solid #0891b2;
  border-radius: 12px;
  padding: 14px;
  background: #082f49;
  color: #e0f2fe;
}
#kc-inline-netz .kc-grid {
  display: grid;
  grid-template-columns: repeat(4, minmax(90px, 1fr));
  gap: 8px;
}
#kc-inline-netz .kc-node {
  padding: 10px;
  border: 2px solid #475569;
  border-radius: 8px;
  background: #0f172a;
}
#kc-inline-netz .kc-node.kc-active {
  border-color: #67e8f9;
  box-shadow: 0 0 0 3px rgb(103 232 249 / .2);
}
#kc-inline-netz button {
  margin-top: 12px;
  padding: 8px 12px;
  border: 0;
  border-radius: 7px;
  font-weight: 700;
  cursor: pointer;
}
</style>

<div id="kc-inline-netz" aria-label="Inline-Netzwerkarchitektur">
  <strong>Inline-Demo: Name → Dienst → Bindung → HTTP</strong>
  <div class="kc-grid">
    <div class="kc-node kc-active" data-label="Name und Adresse">Name<br><small>xebico</small></div>
    <div class="kc-node" data-label="Prozess und Port">Dienst<br><small>8080/tcp</small></div>
    <div class="kc-node" data-label="Bind-Adresse">Bindung<br><small>0.0.0.0</small></div>
    <div class="kc-node" data-label="HTTP-Antwort">HTTP<br><small>200</small></div>
  </div>
  <button id="kc-inline-next" type="button">Nächste Ebene</button>
  <p id="kc-inline-status">JavaScript-Status: noch nicht ausgeführt</p>
</div>

<script>
(() => {
  const root = document.getElementById('kc-inline-netz');
  if (!root) return;
  const nodes = [...root.querySelectorAll('.kc-node')];
  const status = document.getElementById('kc-inline-status');
  let current = 0;
  document.getElementById('kc-inline-next').addEventListener('click', () => {
    nodes[current].classList.remove('kc-active');
    current = (current + 1) % nodes.length;
    nodes[current].classList.add('kc-active');
    status.textContent = `JavaScript aktiv · ${nodes[current].dataset.label}`;
  });
  status.textContent = 'JavaScript aktiv · Name und Adresse';
})();
</script>

Prüfe sichtbar:

- Ist die Architektur als strukturierte Karte vorhanden?
- Erzeugt CSS ein Raster mit hervorgehobener erster Ebene?
- Ändert die Schaltfläche die Hervorhebung und den Statustext?

Dokumentiere jedes Ergebnis mit genau einer der beiden Aktionen.

**HTML**

`printf 'supported\n' > status/ui-html.result`{{exec}}

`printf 'blocked\n' > status/ui-html.result`{{exec}}

**CSS**

`printf 'supported\n' > status/ui-css.result`{{exec}}

`printf 'blocked\n' > status/ui-css.result`{{exec}}

**JavaScript**

`printf 'supported\n' > status/ui-js.result`{{exec}}

`printf 'blocked\n' > status/ui-js.result`{{exec}}

## B · Eingebettete, eigenständige HTML/CSS/JS-Demo

Der folgende Frame versucht eine vom lokalen Pilotdienst gelieferte
interaktive Seite direkt in den Text einzubetten:

<iframe
  title="Interaktive Netzwerkarchitektur der Nachtleitung"
  src="{{TRAFFIC_HOST1_8080}}/architektur"
  style="width:100%;min-height:430px;border:1px solid #64748b;border-radius:10px"
  sandbox="allow-scripts allow-same-origin">
</iframe>

Falls der Frame blockiert oder entfernt wird, öffne denselben Inhalt über
den sicheren Fallback:

[Interaktive Architektur in einem neuen Tab öffnen]({{TRAFFIC_HOST1_8080}}/architektur)

Dokumentiere das Ergebnis des **eingebetteten Frames**:

`printf 'supported\n' > status/ui-iframe.result`{{exec}}

`printf 'blocked\n' > status/ui-iframe.result`{{exec}}

## CHECK

Der CHECK akzeptiert sowohl `supported` als auch `blocked`. Er prüft
zusätzlich, ob der lokale `/architektur`-Endpunkt gültiges HTML mit CSS
und JavaScript liefert. Die tatsächliche Darstellung im Browser bleibt
eine manuelle Plattformbeobachtung.
