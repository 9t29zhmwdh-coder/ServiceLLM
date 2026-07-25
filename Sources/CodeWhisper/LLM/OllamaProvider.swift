import Foundation
import SwiftAgent

/// Delegiert an SwiftAgent's `OllamaProvider`, statt die HTTP-Logik doppelt zu pflegen.
final class OllamaProvider: LLMProvider, @unchecked Sendable {
    private let underlying: SwiftAgent.OllamaProvider

    init(
        model: String = "llama3.2",
        host: String = "localhost",
        port: Int = 11434,
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.underlying = SwiftAgent.OllamaProvider(
            modelName: model,
            host: host,
            port: port,
            temperature: temperature,
            maxTokens: maxTokens
        )
    }

    func chat(messages: [ChatMessage]) async throws -> String {
        let mapped = messages.map { $0.asSwiftAgentMessage() }
        do {
            let response = try await underlying.chat(messages: mapped, tools: nil)
            return response.content
        } catch let error as SwiftAgent.LLMError {
            throw error.asCodeWhisperError()
        }
    }
}
