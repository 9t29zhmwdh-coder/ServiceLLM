<div align="center">
  <img src="RayStudio.png" alt="RayStudio Logo" width="120"/>

  <h1>CodeWhisper</h1>
</div>

[🇬🇧 English Version](README.md)

**macOS AI-Code-Assistent, direkt in Xcode und jeden Texteditor via System-Services integriert.**

Code markieren, Rechtsklick → Services → CodeWhisper: Explain. Fertig.

[![CI](https://github.com/9t29zhmwdh-coder/CodeWhisper/actions/workflows/ci.yml/badge.svg)](https://github.com/9t29zhmwdh-coder/CodeWhisper/actions) [![CodeQL](https://github.com/9t29zhmwdh-coder/CodeWhisper/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/9t29zhmwdh-coder/CodeWhisper/security/code-scanning) [![OpenSSF Scorecard](https://api.securityscorecards.dev/projects/github.com/9t29zhmwdh-coder/CodeWhisper/badge)](https://securityscorecards.dev/viewer/?uri=github.com/9t29zhmwdh-coder/CodeWhisper) [![OpenSSF Best Practices](https://www.bestpractices.dev/projects/13713/badge)](https://www.bestpractices.dev/projects/13713)

![Apple Silicon](https://img.shields.io/badge/Apple-Silicon-000000?logo=apple&logoColor=white) ![Platform](https://img.shields.io/badge/Platform-macOS-lightgrey?logo=apple&logoColor=black) ![Swift](https://img.shields.io/badge/Swift-F05138?logo=swift&logoColor=white) ![AI | Claude Code](https://img.shields.io/badge/AI-Claude_Code-black?logo=anthropic&logoColor=white) ![AI | Copilot](https://img.shields.io/badge/AI-Copilot-black?logo=github&logoColor=white) ![AI | Ollama](https://img.shields.io/badge/AI-Ollama-black?logo=ollama&logoColor=white)

> **So läuft es:** CodeWhisper ist eine native Menüleisten-App ohne Dock-Icon und ohne separaten Hintergrunddienst; sie lebt vollständig in der Statusleiste und im macOS-Services-Menü, während sie läuft.

![CodeWhisper](docs/screenshot.de.png)

---

> 💾 **Download:** [macOS (DMG)](https://github.com/9t29zhmwdh-coder/CodeWhisper/releases/latest/download/CodeWhisper.dmg): immer die neueste Version, nicht codesigniert/notarisiert (Gatekeeper warnt beim ersten Start, Rechtsklick → Öffnen). Oder aus dem Quellcode bauen, siehe Build & Install unten.

---

> 🌱 Neu hier? → [Schritt-für-Schritt-Anleitung für Einsteiger](GETTING_STARTED.md)

---

Die Oberfläche von CodeWhisper ist auf Englisch (Standard) und Deutsch verfügbar, sie folgt automatisch deiner Systemsprache; jederzeit überschreibbar unter Einstellungen → Allgemein.

**In der Praxis:** du markierst Code in einer beliebigen macOS-App (Xcode, VS Code, ein Texteditor, sogar ein Browser-Textfeld), machst einen Rechtsklick, wählst im Services-Untermenü eine der CodeWhisper-Aktionen (Explain, Refactor, Optimize, Add Comments, Find Bugs, Write Tests oder einen selbst definierten Custom-Prompt), und CodeWhisper schickt diese Auswahl an den KI-Anbieter, den du in den Einstellungen konfiguriert hast (ein Cloud-Modell wie Claude, oder ein lokales Modell via Ollama/llama.cpp, falls nichts dein Gerät verlassen soll). Die Antwort erscheint danach so, wie du es eingestellt hast: als schwebendes Popup-Fenster, in die Zwischenablage kopiert, als macOS-Benachrichtigung, oder direkt über deine ursprüngliche Auswahl eingefügt.

![CodeWhisper: Explain aus dem Services-Menü von Xcode ausgelöst, Antwort über ein lokales Ollama-Modell](docs/screenshot-xcode-services.png)

## Funktionen

| Preset | Beschreibung |
|---|---|
| **Explain** | Klare Erklärung des markierten Codes in Prosa |
| **Refactor** | Lesbarkeit und Best Practices verbessern |
| **Optimize** | Performanceoptimiertes Rewrite |
| **Add Comments** | Dokumentations-Kommentare einfügen |
| **Find Bugs** | Bugs und Edge-Cases analysieren |
| **Write Tests** | XCTest Unit Tests generieren |
| **Custom** | Eigener System-Prompt aus den Einstellungen |

### KI-Anbieter

| Anbieter | Hinweise |
|---|---|
| Claude (Anthropic) | Standard: claude-sonnet-4-6 |
| OpenAI | Standard: gpt-4o |
| Mistral | Standard: mistral-large-latest |
| Ollama | Lokal, Host/Port konfigurierbar |
| llama.cpp | Lokal, Host/Port konfigurierbar |

### Ausgabe-Modi

- **Popup-Fenster**: schwebendes Panel mit «Kopieren»- und «Zurückpaste»-Schaltfläche
- **In Zwischenablage kopieren**: lautlos + kurze Benachrichtigung
- **macOS-Benachrichtigung**: im Benachrichtigungszentrum
- **Zurückpaste**: ersetzt den markierten Text im Editor (erfordert Bedienungshilfen-Berechtigung)

---

## Voraussetzungen

- macOS 14 Sonoma oder neuer
- Xcode Command Line Tools (`xcode-select --install`)
- Swift 5.9+

---

## Build & Installation

```bash
git clone https://github.com/9t29zhmwdh-coder/CodeWhisper
cd CodeWhisper
make install
```

`make install` kompiliert den Code, erstellt das `.app`-Bundle, kopiert es nach `/Applications/` und leert den NSServices-Cache.

---

## Erste Einrichtung

1. `/Applications/CodeWhisper.app` öffnen; ein `</>` Symbol erscheint in der Menüleiste.
2. Darauf klicken → **Einstellungen** → KI-Anbieter wählen und API-Key eingeben.
3. Die App einmal neu starten (Beenden → erneut öffnen), damit die Services-Einträge aktiv werden.
4. In Xcode (oder einem anderen Editor): Code markieren → Rechtsklick → **Services** → **CodeWhisper: Explain**.

> **Zurückpaste** erfordert *Bedienungshilfen*-Berechtigung:  
> Systemeinstellungen → Datenschutz & Sicherheit → Bedienungshilfen → CodeWhisper aktivieren.

---

## Deinstallation / Aufräumen

- `/Applications/CodeWhisper.app` löschen
- Gespeicherte Einstellungen entfernen: `defaults delete com.9t29zhmwdh.CodeWhisper`
- Gespeicherte API-Keys aus der Schlüsselbundverwaltung.app entfernen (suche nach "claudeAPIKey", "openAIAPIKey", "mistralAPIKey")
- CodeWhisper vorher beenden (oder neu starten), damit die NSServices-Einträge aus dem Rechtsklick-Services-Menü verschwinden

Es bleiben keine weiteren Dateien oder Hintergrunddienste zurück.

---

## Architektur

```
Sources/CodeWhisper/
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

**Autor:** [Rafael Yilmaz](https://github.com/9t29zhmwdh-coder) · **Status:** Active · ![version](https://img.shields.io/github/v/release/9t29zhmwdh-coder/CodeWhisper?color=6b7280&style=flat-square) · **Lizenz:** MIT
