# Architecture

## Overview

ServiceLLM is a macOS AI code assistant that hooks into the system via NSServices, letting any selected text in any app be processed by an AI model through the right-click Services menu.

```
Sources/ServiceLLM/
├── main.swift                    # .accessory activation policy, app entry point
├── AppDelegate.swift              # 7 NSServices selectors, shared processing pipeline
├── LLM/
│   ├── LLMProvider.swift          # Provider protocol
│   ├── OllamaProvider.swift       # Local, via OpenAICompatibleProvider
│   ├── LlamaCppProvider.swift     # Local, via OpenAICompatibleProvider
│   ├── OpenAICompatibleProvider.swift  # Shared base for Ollama, llama.cpp, OpenAI, Mistral
│   ├── ClaudeProvider.swift       # Anthropic Messages API (different request/response shape)
│   └── Models/                    # ChatMessage, ChatRequest, ChatResponse, ClaudeModels
├── PromptEngine/
│   ├── PromptPreset.swift         # Explain, Refactor, Optimize, Add Comments, Find Bugs, Write Tests, Custom
│   └── PromptBuilder.swift        # Builds the message array for a preset + selected code
├── ResponseFormatter/
│   └── ResponseFormatter.swift    # Strips markdown fences, extracts code blocks
├── OutputEngine/
│   ├── OutputMode.swift           # Popup, clipboard, notification, paste-back
│   └── OutputController.swift     # Delivers the formatted response per the chosen mode
├── Settings/
│   ├── SettingsModel.swift        # Active provider, per-provider config, UserDefaults + Keychain persistence
│   ├── SettingsView.swift         # SwiftUI settings window (Provider / Output / Presets tabs)
│   └── KeychainService.swift      # API key storage
└── UI/
    ├── StatusBarController.swift  # Menu bar icon and menu
    ├── ResponseWindowController.swift
    └── ResponsePopupView.swift    # Floating response panel (Copy / Paste Back)
```

## Design Decisions

- **NSServices, not an Xcode extension**: registering 7 NSServices entries in `Info.plist` makes ServiceLLM available from the right-click Services menu of any Cocoa text view, including Xcode, without an Xcode-specific extension API. Paste Back still requires the user to grant Accessibility permission, since it synthesizes keystrokes into the frontmost app.
- **Provider abstraction**: `LLMProvider` is a protocol; Ollama, llama.cpp, OpenAI, and Mistral all share one `OpenAICompatibleProvider` implementation with different base URLs, while Claude gets its own `ClaudeProvider` since Anthropic's Messages API has a different request/response shape (system prompt as a top-level field, not a message).
- **No third-party dependencies**: pure Foundation + AppKit/SwiftUI, no external Swift packages.
- **Menu-bar only**: `NSApplication.shared.setActivationPolicy(.accessory)` keeps ServiceLLM out of the Dock; it lives entirely in the status bar and the Services menu.

## CI

```yaml
name: CI
on:
  push:
    branches: [main]
  pull_request:
    branches: [main]
jobs:
  build:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v6
      - run: swift build
```
