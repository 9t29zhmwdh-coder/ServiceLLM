# Changelog

All notable changes to CodeWhisper will be documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Fixed

- `NSApp.servicesProvider` was never registered, so every "CodeWhisper: ..." entry in the Services menu silently did nothing regardless of provider or settings.
- LLM responses ignored the app's UI language (English/German) and always came back in English; the Explain preset even hardcoded "in plain English". Responses now follow the current app language.

### Changed

- `OllamaProvider` and `LlamaCppProvider` now delegate to [SwiftAgent](https://github.com/9t29zhmwdh-coder/SwiftAgent) (>= 1.1.0) instead of duplicating its HTTP logic. Claude, OpenAI and Mistral are unaffected.

## [1.0.1] - 2026-07-20

### Changed

- OpenSSF Scorecard workflow and badge.
- `copilot-instructions.md` for consistent AI-assisted contributions.
- Initial XCTest suite for PromptEngine, ResponseFormatter, and Localization (56 tests) with coverage reporting in CI.
- Split the README's security/CI badges onto their own line, separate from the platform/tech/AI badges (they were rendering as a single merged line).

## [1.0.0] - 2026-07-18

First stable release: a real, packaged, installable distribution
(`CodeWhisper.dmg`, attached to every GitHub Release) already exists
for end users, the prerequisite for a 1.0 release per this portfolio's
own SemVer discipline.

## [0.2.5] - 2026-07-12

### Fixed

- Removed 5 em-dashes from `GETTING_STARTED.md`. Swiss German orthography rule: no em-dash/en-dash anywhere in the repo.

## [0.2.4] - 2026-07-12

### Added

- Release workflow (`release.yml`) building the `.app` bundle via the existing `make bundle` target, packaging it into a DMG, and attaching it to a GitHub Release on every `v*` tag push. Previously the only install path was building from source.
- README download section (macOS DMG) in both English and German.

### Fixed

- Pinned the `actions/checkout` action in `ci.yml` to a commit SHA instead of a mutable tag, per the portfolio's supply-chain integrity standard.

## [0.2.3] - 2026-07-11

### Fixed

- SemVer correction: v0.1.1 added a genuine new feature (English/German UI with automatic system-language detection) but was versioned as a patch. Renumbered v0.1.1 through v0.1.3 to v0.2.0 through v0.2.2 (same commits, tags and releases recreated at identical SHAs), per the portfolio's SemVer discipline (patch = fix, minor = feature, major = finished product).

## [0.2.2] - 2026-07-11

### Added

- Documented Dual-Licensing assessment (Community-only) in ROADMAP.md.

## [0.2.1] - 2026-07-11

### Fixed

- Replaced the unmonitored security@raystudio.ch email in SECURITY.md with a GitHub Security Advisory link, matching the rest of the portfolio.

## [0.2.0] - 2026-07-08

### Added

- English (default) and German UI, following the system language automatically, with a manual override in Settings → General (`Localization/L10n.swift`)

### Fixed

- Fixed em-dashes in source code comments and documentation
- Corrected `SECURITY.md`'s claim that processing is "local-only by default"; the default provider is Claude (Anthropic API), a cloud service, unless the user switches to Ollama or llama.cpp
- Corrected `ARCHITECTURE.md`'s file tree and design decisions to match the actual `Sources/CodeWhisper/` layout, and its claim that NSServices integration needs no Accessibility permission (Paste Back specifically does, since it synthesizes keystrokes)
- Fixed the status bar menu not updating immediately when the language was switched at runtime; `@Published`'s publisher fires during `willSet`, before the new value is actually stored, so the menu rebuild read the stale language until deferred to the next run loop turn
- Fixed `Info.plist`'s `CFBundleVersion`/`CFBundleShortVersionString` claiming `1.0.0`/`1.0` while the repository's actual release tag was `v0.1.0`; both now read `0.2.0`

## [0.1.0] - 2026-06-15

### Added

- NSServices integration: 7 selectors (Explain, Refactor, Optimize, Add Comments, Find Bugs, Write Tests, Custom) in the right-click Services menu of any Cocoa text view
- AI providers: Ollama, llama.cpp, Claude (Anthropic), OpenAI, Mistral
- Output modes: popup window, clipboard, macOS notification, paste-back (replaces the selection in place)
- Menu-bar-only app (`.accessory` activation policy), Settings window with Provider/Output/Presets tabs
- API keys stored in the macOS Keychain
