# Changelog

All notable changes to ServiceLLM will be documented here.
Format based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

Releases up to and including 1.0.2 were published under the project's previous name, CodeWhisper.

## [Unreleased]

## [2.1.0] - 2026-07-28

### Added

- The release DMG is now a universal binary, so it runs on Intel Macs as well as Apple Silicon. `make bundle` builds `--arch arm64 --arch x86_64`, and a `verify-arch` step fails the build instead of shipping a silently single-arch app.

### Changed

- The Makefile asks SwiftPM for the binary directory via `--show-bin-path` rather than hardcoding `.build/release`. Multi-arch output lands elsewhere, and that path has moved between SwiftPM releases.
- Requirements and the download line in both READMEs now say universal binary, and the architecture badge reads `Universal arm64 + x86_64`. This supersedes what 2.0.3 documented.

### Note

- Building for x86_64 emits a deprecation warning against recent macOS SDKs, since Apple is phasing the architecture out. The build works, but expect Intel support to become a maintenance decision rather than a given.

## [2.0.3] - 2026-07-28

### Fixed

- Both READMEs listed macOS 14 as the only hardware requirement while the released DMG has always shipped an arm64-only binary, so it will not start on an Intel Mac. The Requirements section and the download line now say so, and point Intel users at building from source.

## [2.0.2] - 2026-07-28

### Changed

- Bumped the pinned GitHub Actions: `actions/checkout` to v7.0.1, `actions/attest-build-provenance` to v4.1.1, `ossf/scorecard-action` to v2.4.4, `github/codeql-action/upload-sarif` to v4.37.3.
- Every checkout pin now sits on the same SHA. `scorecard.yml` was one v7 patch behind the others.
- Version comments next to the pins now carry the full version instead of the bare major, so `# v7.0.1` rather than `# v7`. Dependabot had been bumping the SHA while leaving the comment on the old major, which made the workflows claim a version they were not running.

## [2.0.1] - 2026-07-28

### Removed

- `RayStudio.png`. The studio logo went unused once the app icon took over both README headers in 2.0.0.

## [2.0.0] - 2026-07-28

### Added

- README: a "Local AI or cloud API, your choice" section explaining the privacy tradeoff, plus concrete Find Bugs/Explain examples with real input/output.
- Both READMEs now state explicitly that every preset is language-agnostic and list the languages this covers.
- App icon. `make bundle` generates `AppIcon.icns` from the 1024px `ServiceLLM.png` via `sips` and `iconutil`, so only the source PNG is versioned. The icon also heads both READMEs.

### Changed

- **BREAKING: the project is now called ServiceLLM.** The old name collided with Amazon's CodeWhisperer trademark and with several unrelated products (a Chrome snippet organizer, an Android verification-code app), and it suggested a Swift-only tool. The presets have always been language-agnostic, so the name now says what the app is: an LLM in the macOS Services menu, for any language in any app.
- **BREAKING: the bundle identifier changed** from `com.9t29zhmwdh.CodeWhisper` to `com.9t29zhmwdh.ServiceLLM`. This is the Keychain service name, so stored API keys are no longer found. Enter your key once more in Settings after upgrading. See "Uninstall / Cleanup" in the README for removing the leftovers of the 1.x install.
- Services menu entries are now labelled `ServiceLLM: Explain`, `ServiceLLM: Refactor` and so on. Their `NSMessage` selectors are unchanged.
- Renamed `Sources/CodeWhisper` to `Sources/ServiceLLM`, `Tests/CodeWhisperTests` to `Tests/ServiceLLMTests`, and the SwiftPM targets accordingly.

### Fixed

- README claimed the Write Tests preset generates XCTest unit tests. The prompt has always picked the framework matching the detected language (XCTest, Jest, pytest); both READMEs now say so.

### Note

- 1.0.2 was written to the changelog and Info.plist but never tagged or released. Its changes ship here.

## [1.0.2] - 2026-07-25

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
