import Foundation
import SwiftAgent

/// Delegiert an SwiftAgent's `LlamaCppProvider`, statt die HTTP-Logik doppelt zu pflegen.
final class LlamaCppProvider: LLMProvider, @unchecked Sendable {
    private let underlying: SwiftAgent.LlamaCppProvider

    init(
        model: String = "local-model",
        host: String = "localhost",
        port: Int = 8080,
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.underlying = SwiftAgent.LlamaCppProvider(
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
