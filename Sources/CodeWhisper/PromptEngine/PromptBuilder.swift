import Foundation

enum PromptBuilder {
    static func build(
        preset: PromptPreset,
        code: String,
        customPrompt: String? = nil,
        language: AppLanguage = .en
    ) -> [ChatMessage] {
        let systemText = preset == .custom ? (customPrompt ?? "") : preset.systemPrompt
        let system = ChatMessage.system(systemText + languageInstruction(for: language))
        let user   = ChatMessage.user(code)
        return [system, user]
    }

    static func build(systemPrompt: String, code: String) -> [ChatMessage] {
        [
            .system(systemPrompt),
            .user(code),
        ]
    }

    /// Keeps the LLM's response language in sync with CodeWhisper's UI language,
    /// since the presets themselves are written in English regardless of locale.
    private static func languageInstruction(for language: AppLanguage) -> String {
        switch language {
        case .de: return "\n\nRespond in German (Deutsch)."
        case .en: return ""
        }
    }
}
