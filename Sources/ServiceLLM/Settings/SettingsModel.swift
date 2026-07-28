import Foundation
import Combine

@MainActor
final class SettingsModel: ObservableObject {

    static let shared = SettingsModel()

    enum Provider: String, CaseIterable, Codable {
        case claude    = "Claude (Anthropic)"
        case openai    = "OpenAI"
        case mistral   = "Mistral"
        case ollama    = "Ollama (local)"
        case llamaCpp  = "llama.cpp (local)"

        /// Localized display name; rawValue stays stable for UserDefaults persistence.
        @MainActor var displayName: String {
            switch self {
            case .claude, .openai, .mistral:
                return rawValue
            case .ollama:
                return "Ollama \(L10n.shared.t("provider.suffixLocal"))"
            case .llamaCpp:
                return "llama.cpp \(L10n.shared.t("provider.suffixLocal"))"
            }
        }
    }

    // MARK: - Provider selection
    @Published var activeProvider: Provider {
        didSet { UserDefaults.standard.set(activeProvider.rawValue, forKey: "activeProvider") }
    }

    // MARK: - Models
    @Published var claudeModel: String  { didSet { ud("claudeModel", claudeModel) } }
    @Published var openAIModel: String  { didSet { ud("openAIModel", openAIModel) } }
    @Published var mistralModel: String { didSet { ud("mistralModel", mistralModel) } }
    @Published var ollamaModel: String  { didSet { ud("ollamaModel", ollamaModel) } }
    @Published var llamaCppModel: String { didSet { ud("llamaCppModel", llamaCppModel) } }

    // MARK: - Local server config
    @Published var ollamaHost: String  { didSet { ud("ollamaHost", ollamaHost) } }
    @Published var ollamaPort: Int     { didSet { UserDefaults.standard.set(ollamaPort, forKey: "ollamaPort") } }
    @Published var llamaCppHost: String { didSet { ud("llamaCppHost", llamaCppHost) } }
    @Published var llamaCppPort: Int   { didSet { UserDefaults.standard.set(llamaCppPort, forKey: "llamaCppPort") } }

    // MARK: - Generation params
    @Published var maxTokens: Int    { didSet { UserDefaults.standard.set(maxTokens, forKey: "maxTokens") } }
    @Published var temperature: Double { didSet { UserDefaults.standard.set(temperature, forKey: "temperature") } }

    // MARK: - Output
    @Published var outputMode: OutputMode {
        didSet { ud("outputMode", outputMode.rawValue) }
    }

    // MARK: - Custom prompt for .custom preset
    @Published var customSystemPrompt: String { didSet { ud("customSystemPrompt", customSystemPrompt) } }

    // MARK: - Custom presets
    @Published var customPresets: [CustomPreset] = [] {
        didSet {
            if let data = try? JSONEncoder().encode(customPresets) {
                UserDefaults.standard.set(data, forKey: "customPresets")
            }
        }
    }

    // MARK: - API keys (Keychain)
    var claudeAPIKey: String {
        get { KeychainService.load(key: "claudeAPIKey") }
        set { KeychainService.save(key: "claudeAPIKey", value: newValue); objectWillChange.send() }
    }
    var openAIAPIKey: String {
        get { KeychainService.load(key: "openAIAPIKey") }
        set { KeychainService.save(key: "openAIAPIKey", value: newValue); objectWillChange.send() }
    }
    var mistralAPIKey: String {
        get { KeychainService.load(key: "mistralAPIKey") }
        set { KeychainService.save(key: "mistralAPIKey", value: newValue); objectWillChange.send() }
    }

    private init() {
        let d = UserDefaults.standard
        activeProvider = Provider(rawValue: d.string(forKey: "activeProvider") ?? "") ?? .claude
        claudeModel   = d.string(forKey: "claudeModel")   ?? "claude-sonnet-4-6"
        openAIModel   = d.string(forKey: "openAIModel")   ?? "gpt-4o"
        mistralModel  = d.string(forKey: "mistralModel")  ?? "mistral-large-latest"
        ollamaModel   = d.string(forKey: "ollamaModel")   ?? "llama3.2"
        llamaCppModel = d.string(forKey: "llamaCppModel") ?? "local-model"
        ollamaHost    = d.string(forKey: "ollamaHost")    ?? "localhost"
        ollamaPort    = d.integer(forKey: "ollamaPort")   == 0 ? 11434 : d.integer(forKey: "ollamaPort")
        llamaCppHost  = d.string(forKey: "llamaCppHost")  ?? "localhost"
        llamaCppPort  = d.integer(forKey: "llamaCppPort") == 0 ? 8080  : d.integer(forKey: "llamaCppPort")
        maxTokens     = d.integer(forKey: "maxTokens")    == 0 ? 4096  : d.integer(forKey: "maxTokens")
        temperature   = d.object(forKey: "temperature")  == nil ? 0.2  : d.double(forKey: "temperature")
        outputMode    = OutputMode(rawValue: d.string(forKey: "outputMode") ?? "") ?? .popup
        customSystemPrompt = d.string(forKey: "customSystemPrompt") ?? "You are a helpful coding assistant."
        if let data = d.data(forKey: "customPresets"),
           let decoded = try? JSONDecoder().decode([CustomPreset].self, from: data) {
            customPresets = decoded
        }
    }

    func makeProvider() -> any LLMProvider {
        switch activeProvider {
        case .claude:
            return ClaudeProvider(
                apiKey: claudeAPIKey,
                model: claudeModel,
                maxTokens: maxTokens,
                temperature: temperature
            )
        case .openai:
            return OpenAICompatibleProvider(
                modelName: openAIModel,
                baseURL: URL(string: "https://api.openai.com")!,
                apiKey: openAIAPIKey,
                temperature: temperature,
                maxTokens: maxTokens
            )
        case .mistral:
            return OpenAICompatibleProvider(
                modelName: mistralModel,
                baseURL: URL(string: "https://api.mistral.ai")!,
                apiKey: mistralAPIKey,
                temperature: temperature,
                maxTokens: maxTokens
            )
        case .ollama:
            return OllamaProvider(
                model: ollamaModel,
                host: ollamaHost,
                port: ollamaPort,
                temperature: temperature,
                maxTokens: maxTokens
            )
        case .llamaCpp:
            return LlamaCppProvider(
                model: llamaCppModel,
                host: llamaCppHost,
                port: llamaCppPort,
                temperature: temperature,
                maxTokens: maxTokens
            )
        }
    }

    private func ud(_ key: String, _ value: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
}
