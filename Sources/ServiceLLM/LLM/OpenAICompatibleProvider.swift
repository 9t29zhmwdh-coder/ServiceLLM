import Foundation

final class OpenAICompatibleProvider: LLMProvider, @unchecked Sendable {
    let modelName: String
    let baseURL: URL
    private let apiKey: String?
    private let urlSession: URLSession
    private let timeoutInterval: TimeInterval
    private let temperature: Double?
    private let maxTokens: Int?

    init(
        modelName: String,
        baseURL: URL,
        apiKey: String? = nil,
        urlSession: URLSession = .shared,
        timeoutInterval: TimeInterval = 120,
        temperature: Double? = nil,
        maxTokens: Int? = nil
    ) {
        self.modelName = modelName
        self.baseURL = baseURL
        self.apiKey = apiKey
        self.urlSession = urlSession
        self.timeoutInterval = timeoutInterval
        self.temperature = temperature
        self.maxTokens = maxTokens
    }

    func chat(messages: [ChatMessage]) async throws -> String {
        let req = try buildRequest(messages: messages)
        let (data, response) = try await urlSession.data(for: req)
        try validate(response: response, data: data)
        let decoded = try decode(data: data)
        return decoded.content
    }

    private func buildRequest(messages: [ChatMessage]) throws -> URLRequest {
        let endpoint = baseURL.appendingPathComponent("v1/chat/completions")
        var req = URLRequest(url: endpoint, timeoutInterval: timeoutInterval)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if let key = apiKey, !key.isEmpty {
            req.setValue("Bearer \(key)", forHTTPHeaderField: "Authorization")
        }
        req.httpBody = try JSONEncoder().encode(
            ChatRequest(
                model: modelName,
                messages: messages,
                temperature: temperature,
                maxTokens: maxTokens
            )
        )
        return req
    }

    private func validate(response: URLResponse, data: Data) throws {
        guard let http = response as? HTTPURLResponse else { return }
        guard (200...299).contains(http.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? ""
            throw LLMError.httpError(statusCode: http.statusCode, body: body)
        }
    }

    private func decode(data: Data) throws -> ChatResponse {
        do {
            return try JSONDecoder().decode(ChatResponse.self, from: data)
        } catch {
            throw LLMError.decodingError(underlying: error)
        }
    }
}
