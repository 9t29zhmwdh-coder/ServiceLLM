# Roadmap

## v0.1.0, Initial Release (2026-06-15)

- NSServices integration (right-click context menu), 7 actions: Explain, Refactor, Optimize, Add Comments, Find Bugs, Write Tests, Custom
- Ollama and llama.cpp local backend support
- Cloud AI support: Claude (Anthropic), OpenAI, Mistral
- Settings window (Provider / Output / Presets tabs), API keys in the macOS Keychain
- Output modes: popup window, clipboard, macOS notification, paste-back
- Custom prompt templates (the `Custom` preset's system prompt is user-editable in Settings)

## v0.2.0, Planned

- [ ] Global keyboard shortcut trigger (invoke the active preset without going through the Services menu)
- [ ] Action history (recent requests and responses)
- [ ] Automated test suite (currently no `Tests/` target; CI only runs `swift build`)

## v0.3.0, Planned

- [ ] Multi-model comparison (run the same selection through more than one provider at once)

## v1.0.0, Stable

- [ ] Mac App Store submission
- [ ] Notarization for direct distribution outside the App Store
- [ ] Comprehensive documentation

## Dual-Licensing Readiness

Assessed 2026-07-11: Community-only, not a Dual-Licensing candidate. ServiceLLM is a single-developer productivity tool (AI code assistant via macOS Services) with no team, fleet or multi-tenant dimension anywhere on the roadmap. The planned v1.0.0 monetization path is Mac App Store submission, a paid-app model, not an open-core Community/Commercial split. No natural Enterprise-tier feature exists today; revisit only if a genuine team use case (e.g. shared prompt presets across an engineering org) emerges.
