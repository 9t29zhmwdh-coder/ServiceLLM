import Foundation

struct ChatRequest: Codable, Sendable {
    let model: String
    let messages: [ChatMessage]
    let stream: Bool
    let temperature: Double?
    let maxTokens: Int?

    init(
        model: String,
        messages: [ChatMessage],
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.model = model
        self.messages = messages
        self.stream = false
        self.temperature = temperature
        self.maxTokens = maxTokens
    }

    enum CodingKeys: String, CodingKey {
        case model, messages, stream, temperature
        case maxTokens = "max_tokens"
    }
}
