import SwiftUI

struct SettingsView: View {
    @ObservedObject private var model = SettingsModel.shared
    @ObservedObject private var l10n = L10n.shared

    @State private var claudeKey: String  = ""
    @State private var openAIKey: String  = ""
    @State private var mistralKey: String = ""
    @State private var showNewPreset = false
    @State private var newPresetName = ""
    @State private var newPresetPrompt = ""

    var body: some View {
        TabView {
            providerTab
                .tabItem { Label(l10n.t("settings.tab.provider"), systemImage: "cpu") }
            outputTab
                .tabItem { Label(l10n.t("settings.tab.output"), systemImage: "square.and.arrow.up") }
            presetsTab
                .tabItem { Label(l10n.t("settings.tab.presets"), systemImage: "text.badge.star") }
            generalTab
                .tabItem { Label(l10n.t("settings.tab.general"), systemImage: "globe") }
        }
        .padding(16)
        .frame(width: 520, height: 400)
        .onAppear { loadKeys() }
    }

    // MARK: - Provider tab

    private var providerTab: some View {
        Form {
            Picker(l10n.t("settings.provider.picker"), selection: $model.activeProvider) {
                ForEach(SettingsModel.Provider.allCases, id: \.self) { p in
                    Text(p.displayName).tag(p)
                }
            }

            Divider()

            switch model.activeProvider {
            case .claude:
                TextField(l10n.t("settings.provider.claudeModel"), text: $model.claudeModel)
                SecureField(l10n.t("settings.provider.apiKey"), text: $claudeKey)
                    .onChange(of: claudeKey) { _, new in model.claudeAPIKey = new }

            case .openai:
                TextField(l10n.t("settings.provider.openaiModel"), text: $model.openAIModel)
                SecureField(l10n.t("settings.provider.apiKey"), text: $openAIKey)
                    .onChange(of: openAIKey) { _, new in model.openAIAPIKey = new }

            case .mistral:
                TextField(l10n.t("settings.provider.mistralModel"), text: $model.mistralModel)
                SecureField(l10n.t("settings.provider.apiKey"), text: $mistralKey)
                    .onChange(of: mistralKey) { _, new in model.mistralAPIKey = new }

            case .ollama:
                TextField(l10n.t("settings.provider.modelName"), text: $model.ollamaModel)
                HStack {
                    TextField(l10n.t("settings.provider.host"), text: $model.ollamaHost)
                    TextField(l10n.t("settings.provider.port"), value: $model.ollamaPort, formatter: NumberFormatter())
                        .frame(width: 70)
                }

            case .llamaCpp:
                TextField(l10n.t("settings.provider.modelName"), text: $model.llamaCppModel)
                HStack {
                    TextField(l10n.t("settings.provider.host"), text: $model.llamaCppHost)
                    TextField(l10n.t("settings.provider.port"), value: $model.llamaCppPort, formatter: NumberFormatter())
                        .frame(width: 70)
                }
            }

            Divider()

            HStack {
                Text(l10n.t("settings.provider.maxTokens"))
                TextField("", value: $model.maxTokens, formatter: NumberFormatter())
                    .frame(width: 80)
            }
            HStack {
                Text(l10n.t("settings.provider.temperature"))
                Slider(value: $model.temperature, in: 0...2, step: 0.05)
                Text(String(format: "%.2f", model.temperature))
                    .frame(width: 40)
            }
        }
    }

    // MARK: - Output tab

    private var outputTab: some View {
        Form {
            Picker(l10n.t("settings.output.mode"), selection: $model.outputMode) {
                ForEach(OutputMode.allCases, id: \.self) { m in
                    Text(l10n.t(m.localizationKey)).tag(m)
                }
            }
            .pickerStyle(.radioGroup)
        }
    }

    // MARK: - Presets tab

    private var presetsTab: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(l10n.t("settings.presets.customPromptLabel"))
                .font(.headline)
            TextEditor(text: $model.customSystemPrompt)
                .frame(height: 80)
                .border(Color.secondary.opacity(0.4))

            Divider()

            Text(l10n.t("settings.presets.savedLabel"))
                .font(.headline)

            List {
                ForEach(model.customPresets) { preset in
                    VStack(alignment: .leading) {
                        Text(preset.name).bold()
                        Text(preset.systemPrompt)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }
                .onDelete { idx in model.customPresets.remove(atOffsets: idx) }
            }
            .frame(height: 120)

            if showNewPreset {
                GroupBox {
                    VStack(alignment: .leading, spacing: 6) {
                        TextField(l10n.t("settings.presets.namePlaceholder"), text: $newPresetName)
                        TextEditor(text: $newPresetPrompt)
                            .frame(height: 60)
                            .border(Color.secondary.opacity(0.4))
                        HStack {
                            Button(l10n.t("settings.presets.add")) {
                                guard !newPresetName.isEmpty else { return }
                                model.customPresets.append(
                                    CustomPreset(id: UUID(), name: newPresetName, systemPrompt: newPresetPrompt)
                                )
                                newPresetName = ""; newPresetPrompt = ""; showNewPreset = false
                            }
                            Button(l10n.t("settings.presets.cancel")) { showNewPreset = false }
                        }
                    }
                }
            } else {
                Button(l10n.t("settings.presets.newPreset")) { showNewPreset = true }
            }
        }
        .padding(8)
    }

    // MARK: - General tab

    private var generalTab: some View {
        Form {
            Picker(l10n.t("settings.general.language"), selection: Binding<AppLanguage?>(
                get: { l10n.override },
                set: { l10n.override = $0 }
            )) {
                Text(l10n.t("settings.general.languageSystem")).tag(AppLanguage?.none)
                ForEach(AppLanguage.allCases, id: \.self) { lang in
                    Text(lang.displayName).tag(AppLanguage?.some(lang))
                }
            }
            .pickerStyle(.radioGroup)
        }
    }

    private func loadKeys() {
        claudeKey  = model.claudeAPIKey
        openAIKey  = model.openAIAPIKey
        mistralKey = model.mistralAPIKey
    }
}
