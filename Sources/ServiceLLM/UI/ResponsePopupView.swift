import SwiftUI

struct ResponsePopupView: View {
    let text: String
    var onCopy: (() -> Void)?
    var onPasteBack: (() -> Void)?
    var onClose: (() -> Void)?

    @State private var isCopied = false
    @ObservedObject private var l10n = L10n.shared

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "sparkles")
                    .foregroundStyle(.purple)
                Text("ServiceLLM")
                    .fontWeight(.semibold)
                Spacer()
                Button(action: { onClose?() }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.regularMaterial)

            Divider()

            // Response text
            ScrollView {
                Text(text)
                    .textSelection(.enabled)
                    .font(.system(.body, design: .monospaced))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(16)
            }

            Divider()

            // Actions
            HStack(spacing: 8) {
                Spacer()

                if onPasteBack != nil {
                    Button(l10n.t("popup.pasteBack")) { onPasteBack?() }
                        .keyboardShortcut(.return, modifiers: .command)
                }

                Button(isCopied ? l10n.t("popup.copied") : l10n.t("popup.copy")) {
                    onCopy?()
                    isCopied = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { isCopied = false }
                }
                .keyboardShortcut("c", modifiers: .command)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(.regularMaterial)
        }
    }
}

struct LoadingPopupView: View {
    var preset: String
    var onCancel: (() -> Void)?

    @State private var dots = ""
    @State private var timer: Timer?
    @ObservedObject private var l10n = L10n.shared

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text("\(l10n.t("popup.asking")) \(preset)\(dots)")
                .foregroundStyle(.secondary)
            Button(l10n.t("popup.cancel")) { onCancel?() }
                .buttonStyle(.borderless)
        }
        .frame(width: 260, height: 140)
        .onAppear {
            timer = Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { [self] _ in
                Task { @MainActor in
                    dots = dots.count < 3 ? dots + "." : ""
                }
            }
        }
        .onDisappear { timer?.invalidate() }
    }
}
