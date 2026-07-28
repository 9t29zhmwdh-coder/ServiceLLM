import Foundation

struct ChatMessage: Codable, Sendable, Equatable {
    enum Role: String, Codable, Sendable, Equatable {
        case system, user, assistant
    }

    let role: Role
    let content: String

    static func system(_ content: String) -> ChatMessage {
        ChatMessage(role: .system, content: content)
    }
    static func user(_ content: String) -> ChatMessage {
        ChatMessage(role: .user, content: content)
    }
    static func assistant(_ content: String) -> ChatMessage {
        ChatMessage(role: .assistant, content: content)
    }
}
