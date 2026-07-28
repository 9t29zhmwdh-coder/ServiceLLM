import Foundation

enum PromptPreset: String, CaseIterable, Sendable {
    case explain      = "Explain"
    case refactor     = "Refactor"
    case optimize     = "Optimize"
    case addComments  = "Add Comments"
    case findBugs     = "Find Bugs"
    case writeTests   = "Write Tests"
    case custom       = "Custom"

    var systemPrompt: String {
        switch self {
        case .explain:
            return "You are a helpful code explainer. Explain the following code clearly and concisely in plain language. Focus on what it does, how it works, and any notable patterns or edge cases."
        case .refactor:
            return "You are a code refactoring expert. Refactor the following code for clarity, readability, and best practices. Apply SOLID principles where appropriate. Return only the refactored code without explanations."
        case .optimize:
            return "You are a performance optimization expert. Optimize the following code for speed and efficiency. Add brief inline comments only where the optimization is non-obvious. Return only the optimized code."
        case .addComments:
            return "Add clear, professional documentation comments to the following code. Use the appropriate style for the detected language (e.g. Swift DocC, JSDoc, Python docstrings). Return the complete commented code."
        case .findBugs:
            return "You are an expert code reviewer. Analyze the following code for bugs, logic errors, edge cases, security issues, and potential crashes. List each problem with a brief explanation and a concrete fix suggestion."
        case .writeTests:
            return "Write comprehensive unit tests for the following code. Use the appropriate testing framework for the detected language (e.g. XCTest for Swift, Jest for TypeScript, pytest for Python). Cover happy paths, edge cases, and error conditions. Return only the test code."
        case .custom:
            return ""  // caller injects the custom prompt via PromptBuilder
        }
    }

    var displayIcon: String {
        switch self {
        case .explain:     return "💡"
        case .refactor:    return "🔧"
        case .optimize:    return "⚡"
        case .addComments: return "📝"
        case .findBugs:    return "🐛"
        case .writeTests:  return "🧪"
        case .custom:      return "✨"
        }
    }

    /// Localization key for L10n.t(_:); resolve at a @MainActor call site, not here,
    /// so this enum can stay Sendable and rawValue stays stable for NSServices/persistence.
    var localizationKey: String {
        switch self {
        case .explain:     return "preset.explain"
        case .refactor:    return "preset.refactor"
        case .optimize:    return "preset.optimize"
        case .addComments: return "preset.addComments"
        case .findBugs:    return "preset.findBugs"
        case .writeTests:  return "preset.writeTests"
        case .custom:      return "preset.custom"
        }
    }
}

struct CustomPreset: Codable, Sendable, Identifiable {
    var id: UUID = UUID()
    var name: String
    var systemPrompt: String
}
