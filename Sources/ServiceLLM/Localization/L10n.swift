import Foundation
import Combine

enum AppLanguage: String, CaseIterable, Sendable {
    case en
    case de

    static func systemDefault() -> AppLanguage {
        let preferred = Locale.preferredLanguages.first ?? "en"
        return preferred.hasPrefix("de") ? .de : .en
    }

    var displayName: String {
        switch self {
        case .en: return "English"
        case .de: return "Deutsch"
        }
    }
}

@MainActor
final class L10n: ObservableObject {
    static let shared = L10n()

    /// nil means "follow system language"; a concrete value means the user overrode it in Settings.
    @Published var override: AppLanguage? {
        didSet {
            if let override {
                UserDefaults.standard.set(override.rawValue, forKey: "appLanguageOverride")
            } else {
                UserDefaults.standard.removeObject(forKey: "appLanguageOverride")
            }
        }
    }

    var language: AppLanguage { override ?? AppLanguage.systemDefault() }

    private init() {
        if let stored = UserDefaults.standard.string(forKey: "appLanguageOverride"),
           let lang = AppLanguage(rawValue: stored) {
            override = lang
        } else {
            override = nil
        }
    }

    func t(_ key: String) -> String {
        strings[language]?[key] ?? strings[.en]?[key] ?? key
    }
}

private let strings: [AppLanguage: [String: String]] = [
    .en: [
        "settings.windowTitle": "ServiceLLM Settings",
        "settings.tab.provider": "Provider",
        "settings.tab.output": "Output",
        "settings.tab.presets": "Presets",
        "settings.tab.general": "General",

        "settings.provider.picker": "Provider",
        "settings.provider.claudeModel": "Claude Model",
        "settings.provider.openaiModel": "OpenAI Model",
        "settings.provider.mistralModel": "Mistral Model",
        "settings.provider.modelName": "Model name",
        "settings.provider.apiKey": "API Key",
        "settings.provider.host": "Host",
        "settings.provider.port": "Port",
        "settings.provider.maxTokens": "Max Tokens",
        "settings.provider.temperature": "Temperature",

        "settings.output.mode": "Output Mode",

        "settings.presets.customPromptLabel": "Custom prompt for \"Custom\" preset:",
        "settings.presets.savedLabel": "Saved Custom Presets:",
        "settings.presets.namePlaceholder": "Name",
        "settings.presets.add": "Add",
        "settings.presets.cancel": "Cancel",
        "settings.presets.newPreset": "+ New Preset",

        "settings.general.language": "Language",
        "settings.general.languageSystem": "System",

        "statusbar.settings": "Settings…",
        "statusbar.quit": "Quit ServiceLLM",

        "popup.copy": "Copy",
        "popup.copied": "Copied!",
        "popup.pasteBack": "Paste Back",
        "popup.asking": "Asking",
        "popup.cancel": "Cancel",

        "preset.explain": "Explain",
        "preset.refactor": "Refactor",
        "preset.optimize": "Optimize",
        "preset.addComments": "Add Comments",
        "preset.findBugs": "Find Bugs",
        "preset.writeTests": "Write Tests",
        "preset.custom": "Custom",

        "outputMode.popup": "Popup Window",
        "outputMode.clipboard": "Copy to Clipboard",
        "outputMode.notification": "macOS Notification",
        "outputMode.pasteBack": "Paste Back into Editor",

        "provider.suffixLocal": "(local)",
        "notification.copiedToClipboard": "Response copied to clipboard.",
        "error.prefix": "Error",
    ],
    .de: [
        "settings.windowTitle": "ServiceLLM-Einstellungen",
        "settings.tab.provider": "Anbieter",
        "settings.tab.output": "Ausgabe",
        "settings.tab.presets": "Vorlagen",
        "settings.tab.general": "Allgemein",

        "settings.provider.picker": "Anbieter",
        "settings.provider.claudeModel": "Claude-Modell",
        "settings.provider.openaiModel": "OpenAI-Modell",
        "settings.provider.mistralModel": "Mistral-Modell",
        "settings.provider.modelName": "Modellname",
        "settings.provider.apiKey": "API-Schlüssel",
        "settings.provider.host": "Host",
        "settings.provider.port": "Port",
        "settings.provider.maxTokens": "Max. Tokens",
        "settings.provider.temperature": "Temperatur",

        "settings.output.mode": "Ausgabemodus",

        "settings.presets.customPromptLabel": "Eigener Prompt für die Vorlage „Custom“:",
        "settings.presets.savedLabel": "Gespeicherte eigene Vorlagen:",
        "settings.presets.namePlaceholder": "Name",
        "settings.presets.add": "Hinzufügen",
        "settings.presets.cancel": "Abbrechen",
        "settings.presets.newPreset": "+ Neue Vorlage",

        "settings.general.language": "Sprache",
        "settings.general.languageSystem": "System",

        "statusbar.settings": "Einstellungen…",
        "statusbar.quit": "ServiceLLM beenden",

        "popup.copy": "Kopieren",
        "popup.copied": "Kopiert!",
        "popup.pasteBack": "Zurück einfügen",
        "popup.asking": "Frage",
        "popup.cancel": "Abbrechen",

        "preset.explain": "Erklären",
        "preset.refactor": "Refaktorisieren",
        "preset.optimize": "Optimieren",
        "preset.addComments": "Kommentare hinzufügen",
        "preset.findBugs": "Bugs finden",
        "preset.writeTests": "Tests schreiben",
        "preset.custom": "Custom",

        "outputMode.popup": "Popup-Fenster",
        "outputMode.clipboard": "In Zwischenablage kopieren",
        "outputMode.notification": "macOS-Benachrichtigung",
        "outputMode.pasteBack": "Zurück in den Editor einfügen",

        "provider.suffixLocal": "(lokal)",
        "notification.copiedToClipboard": "Antwort in die Zwischenablage kopiert.",
        "error.prefix": "Fehler",
    ],
]
