import Foundation

// Anthropic Messages API request/response types.
// Different from OpenAI format: system prompt is a top-level field.

struct ClaudeRequest: Encodable, Sendable {
    let model: String
    let maxTokens: Int
    let system: String?
    let messages: [ClaudeMessage]
    let temperature: Double?

    init(
        model: String,
        maxTokens: Int = 4096,
        system: String? = nil,
        messages: [ClaudeMessage],
        temperature: Double? = nil
    ) {
        self.model = model
        self.maxTokens = maxTokens
        self.system = system
        self.messages = messages
        self.temperature = temperature
    }

    enum CodingKeys: String, CodingKey {
        case model, system, messages, temperature
        case maxTokens = "max_tokens"
    }
}

struct ClaudeMessage: Codable, Sendable {
    let role: String  // "user" | "assistant"
    let content: String

    static func user(_ content: String) -> ClaudeMessage {
        ClaudeMessage(role: "user", content: content)
    }
    static func assistant(_ content: String) -> ClaudeMessage {
        ClaudeMessage(role: "assistant", content: content)
    }
}

struct ClaudeResponse: Decodable, Sendable {
    let id: String
    let content: [ContentBlock]
    let model: String

    struct ContentBlock: Decodable, Sendable {
        let type: String
        let text: String?
    }

    var text: String {
        content.compactMap { $0.type == "text" ? $0.text : nil }.joined()
    }
}
