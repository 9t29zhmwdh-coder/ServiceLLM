import Foundation

struct ChatResponse: Codable, Sendable {
    let id: String
    let model: String
    let choices: [Choice]

    struct Choice: Codable, Sendable {
        let index: Int
        let message: ChatMessage
        let finishReason: String?

        enum CodingKeys: String, CodingKey {
            case index, message
            case finishReason = "finish_reason"
        }
    }

    var content: String {
        choices.first?.message.content ?? ""
    }
}
