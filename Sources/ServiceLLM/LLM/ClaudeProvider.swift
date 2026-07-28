import Foundation

// Anthropic Messages API, format differs from OpenAI.
// System prompt is a top-level field; messages array contains only user/assistant turns.
final class ClaudeProvider: LLMProvider, @unchecked Sendable {
    private let apiKey: String
    private let model: String
    private let maxTokens: Int
    private let temperature: Double?
    private let urlSession: URLSession

    private static let endpoint = URL(string: "https://api.anthropic.com/v1/messages")!

    init(
        apiKey: String,
        model: String = "claude-sonnet-4-6",
        maxTokens: Int = 4096,
        temperature: Double? = nil,
        urlSession: URLSession = .shared
    ) {
        self.apiKey = apiKey
        self.model = model
        self.maxTokens = maxTokens
        self.temperature = temperature
        self.urlSession = urlSession
    }

    func chat(messages: [ChatMessage]) async throws -> String {
        guard !apiKey.isEmpty else { throw LLMError.noAPIKey }

        let system = messages.first(where: { $0.role == .system })?.content
        let turns: [ClaudeMessage] = messages
            .filter { $0.role != .system }
            .map { msg in
                msg.role == .user
                    ? .user(msg.content)
                    : .assistant(msg.content)
            }

        let body = ClaudeRequest(
            model: model,
            maxTokens: maxTokens,
            system: system,
            messages: turns,
            temperature: temperature
        )

        var req = URLRequest(url: Self.endpoint, timeoutInterval: 120)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "content-type")
        req.setValue(apiKey, forHTTPHeaderField: "x-api-key")
        req.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
        req.httpBody = try JSONEncoder().encode(body)

        let (data, response) = try await urlSession.data(for: req)

        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            let bodyStr = String(data: data, encoding: .utf8) ?? ""
            throw LLMError.httpError(statusCode: http.statusCode, body: bodyStr)
        }

        do {
            let decoded = try JSONDecoder().decode(ClaudeResponse.self, from: data)
            return decoded.text
        } catch {
            throw LLMError.decodingError(underlying: error)
        }
    }
}
