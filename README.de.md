<div align="center">
  <img src="ServiceLLM.png" alt="ServiceLLM Icon" width="120"/>

  <h1>ServiceLLM</h1>
</div>

[🇬🇧 English Version](README.md)

**AI-Code-Assistent im macOS-Services-Menü: jede Sprache, jede App, lokale oder Cloud-Modelle.**

Code markieren, Rechtsklick → Services → ServiceLLM: Explain. Fertig.

Kein Fenster, in das du wechseln musst, kein Einfügen, kein Verlieren der
Stelle. Das funktioniert in Xcode, in VS Code, in einem Texteditor, in einem
Browser-Textfeld, weil das Services-Menü zu macOS gehört und nicht zu einer
App.

**Nichts für dich, wenn** du ohnehin in einem Editor mit eingebautem
AI-Assistenten arbeitest. Copilot und Cursor sehen die umgebende Datei, also
mehr Kontext, als eine Markierung mitbringt. Das hier ist für die anderen
zwanzig Programme, in denen es gar keinen Assistenten gibt.

[![CI](https://github.com/9t29zhmwdh-coder/ServiceLLM/actions/workflows/ci.yml/badge.svg)](https://github.com/9t29zhmwdh-coder/ServiceLLM/actions) [![CodeQL](https://github.com/9t29zhmwdh-coder/ServiceLLM/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/9t29zhmwdh-coder/ServiceLLM/security/code-scanning) [![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/9t29zhmwdh-coder/ServiceLLM/badge)](https://securityscorecards.dev/viewer/?uri=github.com/9t29zhmwdh-coder/ServiceLLM) [![OpenSSF Best Practices](https://www.bestpractices.dev/projects/13713/badge)](https://www.bestpractices.dev/projects/13713)

![Universal Binary](https://img.shields.io/badge/Universal-arm64_+_x86__64-000000?logo=apple&logoColor=white) ![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey?logo=apple&logoColor=black) ![Swift](https://img.shields.io/badge/Swift-F05138?logo=swift&logoColor=white) ![AI | Claude Code](https://img.shields.io/badge/AI-Claude_Code-black?logo=anthropic&logoColor=white) ![AI | Copilot](https://img.shields.io/badge/AI-Copilot-black?logo=github&logoColor=white) ![AI | Ollama](https://img.shields.io/badge/AI-Ollama-black?logo=ollama&logoColor=white) ![macOS](https://img.shields.io/badge/macOS-14+-lightgrey?logo=apple)

> **So läuft es:** ServiceLLM ist eine native Menüleisten-App ohne Dock-Icon und ohne separaten Hintergrunddienst; sie lebt vollständig in der Statusleiste und im macOS-Services-Menü, während sie läuft.

![ServiceLLM](docs/screenshot.de.png)

---

> 💾 **Download:** [macOS (DMG)](https://github.com/9t29zhmwdh-coder/ServiceLLM/releases/latest/download/ServiceLLM.dmg): immer die neueste Version, Universal Binary für Apple Silicon und Intel, nicht codesigniert/notarisiert (Gatekeeper warnt beim ersten Start, Rechtsklick → Öffnen). Oder aus dem Quellcode bauen, siehe Build & Install unten.

---

> 🌱 Neu hier? → [Schritt-für-Schritt-Anleitung für Einsteiger](GETTING_STARTED.md)

---

Die Oberfläche von ServiceLLM ist auf Englisch (Standard) und Deutsch verfügbar, sie folgt automatisch deiner Systemsprache; jederzeit überschreibbar unter Einstellungen → Allgemein.

**In der Praxis:** du markierst Code in einer beliebigen Sprache, in einer beliebigen macOS-App (Xcode, VS Code, ein Texteditor, sogar ein Browser-Textfeld), machst einen Rechtsklick, wählst im Services-Untermenü eine der ServiceLLM-Aktionen (Explain, Refactor, Optimize, Add Comments, Find Bugs, Write Tests oder einen selbst definierten Custom-Prompt), und ServiceLLM schickt diese Auswahl an den KI-Anbieter, den du in den Einstellungen konfiguriert hast (ein Cloud-Modell wie Claude, oder ein lokales Modell via Ollama/llama.cpp, falls nichts dein Gerät verlassen soll). Die Antwort erscheint danach so, wie du es eingestellt hast: als schwebendes Popup-Fenster, in die Zwischenablage kopiert, als macOS-Benachrichtigung, oder direkt über deine ursprüngliche Auswahl eingefügt.

![ServiceLLM: Explain aus dem Services-Menü von Xcode ausgelöst, Antwort über ein lokales Ollama-Modell](docs/screenshot-xcode-services.png)

## Funktionen

| Preset | Beschreibung |
|---|---|
| **Explain** | Klare Erklärung des markierten Codes in Prosa |
| **Refactor** | Lesbarkeit und Best Practices verbessern |
| **Optimize** | Performanceoptimiertes Rewrite |
| **Add Comments** | Dokumentations-Kommentare einfügen |
| **Find Bugs** | Bugs und Edge-Cases analysieren |
| **Write Tests** | Unit Tests im Framework der erkannten Sprache generieren (XCTest, Jest, pytest) |
| **Custom** | Eigener System-Prompt aus den Einstellungen |

Jedes Preset ist sprachunabhängig: der Prompt weist das Modell an, mit der Sprache zu arbeiten, die es in der Auswahl erkennt. Swift, Python, TypeScript, Go, Rust, SQL, Shell und alles andere, was dein Modell kennt, funktioniert damit gleichermassen.

### KI-Anbieter

| Anbieter | Hinweise |
|---|---|
| Claude (Anthropic) | Standard: claude-sonnet-4-6 |
| OpenAI | Standard: gpt-4o |
| Mistral | Standard: mistral-large-latest |
| Ollama | Lokal, Host/Port konfigurierbar |
| llama.cpp | Lokal, Host/Port konfigurierbar |

### Lokale KI oder Cloud API, deine Wahl

ServiceLLM legt sich nicht fest. Zeig auf ein lokales Modell (Ollama oder llama.cpp), und deine Auswahl verlässt nie deinen Mac, kein API-Schlüssel nötig. Oder zeig auf ein Cloud-Modell (Claude, OpenAI, Mistral) mit eigenem API-Schlüssel für ein stärkeres Modell, auf Kosten davon, dass diese Auswahl an den jeweiligen Anbieter geschickt wird. Jederzeit umschaltbar in den Einstellungen, Temperature/Token-Limits pro Preset gelten in beiden Fällen.

### Beispiele

Die beiden Beispiele unten sind zufällig Swift, aber die Presets sind an keine Sprache gebunden.

**Bugs finden**, angewendet auf:
```swift
func divide(_ a: Int, _ b: Int) -> Int {
    return a / b
}
```
> Teilt ohne Prüfung auf `b == 0`, was zur Laufzeit mit einem Division-durch-null-Absturz endet. Ausserdem schneidet `Int`-Division den Nachkommaanteil ab, was stillschweigend Ergebnisse verwirft, falls das nicht beabsichtigt war. Vorschlag: einen Optional zurückgeben oder werfen, und vorher `b != 0` prüfen.

**Erklären**, angewendet auf:
```swift
let cache = NSCache<NSString, UIImage>()
```
> Erstellt einen Cache im Arbeitsspeicher, der String-Schlüssel auf Bilder abbildet. Anders als ein einfaches Dictionary räumt `NSCache` Einträge automatisch bei Speicherdruck und ist thread-sicher, deshalb ist es die Standardwahl für Bild-Caches statt eines `[String: UIImage]`.

### Ausgabe-Modi

- **Popup-Fenster**: schwebendes Panel mit «Kopieren»- und «Zurückpaste»-Schaltfläche
- **In Zwischenablage kopieren**: lautlos + kurze Benachrichtigung
- **macOS-Benachrichtigung**: im Benachrichtigungszentrum
- **Zurückpaste**: ersetzt den markierten Text im Editor (erfordert Bedienungshilfen-Berechtigung)

---

## Voraussetzungen

- macOS 14 Sonoma oder neuer
- Apple Silicon oder Intel. Das released DMG ist ein Universal Binary für beide, und `make bundle` erzeugt ebenfalls eines.
- Xcode Command Line Tools (`xcode-select --install`)
- Swift 5.9+

---

## Build & Installation

```bash
git clone https://github.com/9t29zhmwdh-coder/ServiceLLM
cd ServiceLLM
make install
```

`make install` kompiliert den Code, erstellt das `.app`-Bundle, kopiert es nach `/Applications/` und leert den NSServices-Cache.

---

## Erste Einrichtung

1. `/Applications/ServiceLLM.app` öffnen; ein `</>` Symbol erscheint in der Menüleiste.
2. Darauf klicken → **Einstellungen** → KI-Anbieter wählen und API-Key eingeben.
3. Die App einmal neu starten (Beenden → erneut öffnen), damit die Services-Einträge aktiv werden.
4. In Xcode (oder einem anderen Editor): Code markieren → Rechtsklick → **Services** → **ServiceLLM: Explain**.

> **Zurückpaste** erfordert *Bedienungshilfen*-Berechtigung:  
> Systemeinstellungen → Datenschutz & Sicherheit → Bedienungshilfen → ServiceLLM aktivieren.

---

## Deinstallation / Aufräumen

- `/Applications/ServiceLLM.app` löschen
- Gespeicherte Einstellungen entfernen: `defaults delete com.9t29zhmwdh.ServiceLLM`
- Gespeicherte API-Keys aus der Schlüsselbundverwaltung.app entfernen (suche nach "claudeAPIKey", "openAIAPIKey", "mistralAPIKey")
- ServiceLLM vorher beenden (oder neu starten), damit die NSServices-Einträge aus dem Rechtsklick-Services-Menü verschwinden

Es bleiben keine weiteren Dateien oder Hintergrunddienste zurück.

> **Umstieg von 1.x (CodeWhisper):** die App wurde in 2.0.0 umbenannt, der Bundle-Identifier hat von `com.9t29zhmwdh.CodeWhisper` auf `com.9t29zhmwdh.ServiceLLM` gewechselt. Dein API-Key liegt im Schlüsselbund noch unter der alten Kennung, trage ihn nach dem Update also einmal neu in den Einstellungen ein. Danach die alte `/Applications/CodeWhisper.app` löschen und mit `defaults delete com.9t29zhmwdh.CodeWhisper` die zurückgebliebenen Einstellungen entfernen.

---

## Architektur

```
Sources/ServiceLLM/
├── LLM/               # Provider-Protokoll + Claude / OpenAI-compat / Ollama / llama.cpp
├── PromptEngine/      # Presets und Prompt-Builder
├── ResponseFormatter/ # Markdown-Trim, Code-Block-Extraktion
├── OutputEngine/      # Popup, Zwischenablage, Benachrichtigung, Zurückpaste
├── Settings/          # Keychain, Modell, UserDefaults-Persistenz
├── Localization/      # L10n: EN/DE-Strings, Systemsprache-Erkennung + manueller Override
├── UI/                # NSPanel-Popup, Statusleisten-Menü
├── AppDelegate.swift  # 7 NSServices-Selektoren → gemeinsame Pipeline
└── main.swift         # .accessory Aktivierungsrichtlinie
```

---

**Autor:** [Rafael Yilmaz](https://github.com/9t29zhmwdh-coder) · **Status:** Active · ![version](https://img.shields.io/github/v/release/9t29zhmwdh-coder/ServiceLLM?color=6b7280&style=flat-square) · **Lizenz:** MIT
