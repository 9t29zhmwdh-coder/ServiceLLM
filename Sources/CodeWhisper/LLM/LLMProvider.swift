import Foundation
import SwiftAgent

protocol LLMProvider: Sendable {
    func chat(messages: [ChatMessage]) async throws -> String
}

enum LLMError: LocalizedError, Sendable {
    case invalidURL(String)
    case httpError(statusCode: Int, body: String)
    case decodingError(underlying: Error)
    case timeout
    case noAPIKey
    case providerError(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL(let u):      return "Invalid URL: \(u)"
        case .httpError(let c, let b): return "HTTP \(c): \(b.prefix(200))"
        case .decodingError(let e):   return "Decode error: \(e.localizedDescription)"
        case .timeout:                return "Request timed out"
        case .noAPIKey:               return "No API key configured. Open Settings to add one."
        case .providerError(let m):   return m
        }
    }
}

extension ChatMessage {
    /// Used by the local providers that delegate to SwiftAgent's HTTP layer.
    func asSwiftAgentMessage() -> SwiftAgent.ChatMessage {
        let role: SwiftAgent.ChatMessage.Role
        switch self.role {
        case .system:    role = .system
        case .user:      role = .user
        case .assistant: role = .assistant
        }
        return SwiftAgent.ChatMessage(role: role, content: content)
    }
}

extension SwiftAgent.LLMError {
    /// Bridges SwiftAgent's error cases onto CodeWhisper's own `LLMError`,
    /// used by the local providers that now delegate to SwiftAgent.
    func asCodeWhisperError() -> LLMError {
        switch self {
        case .invalidURL(let u):            return .invalidURL(u)
        case .httpError(let c, let b):      return .httpError(statusCode: c, body: b)
        case .decodingError(let e):         return .decodingError(underlying: e)
        case .timeout:                      return .timeout
        case .streamingError(let m):        return .providerError(m)
        case .cancelled:                    return .providerError("Request cancelled")
        }
    }
}
