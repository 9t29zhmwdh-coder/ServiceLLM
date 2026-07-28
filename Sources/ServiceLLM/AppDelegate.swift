import AppKit

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusBarController: StatusBarController?
    @MainActor static var callingApp: NSRunningApplication?

    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenterDelegate.register()
        NSApp.servicesProvider = self
        Task { @MainActor in
            statusBarController = StatusBarController()
        }
    }

    // MARK: - Shared pipeline

    @MainActor private func handleService(pasteboard: NSPasteboard, preset: PromptPreset) {
        Self.callingApp = NSWorkspace.shared.frontmostApplication
        guard let code = pasteboard.string(forType: .string), !code.isEmpty else { return }

        let settings = SettingsModel.shared
        let provider = settings.makeProvider()
        let messages = PromptBuilder.build(
            preset: preset,
            code: code,
            customPrompt: settings.customSystemPrompt,
            language: L10n.shared.language
        )

        ResponseWindowController.shared.showLoading(preset: L10n.shared.t(preset.localizationKey)) {
            ResponseWindowController.shared.close()
        }

        Task {
            do {
                let raw  = try await provider.chat(messages: messages)
                let text = ResponseFormatter.format(raw)
                await MainActor.run {
                    ResponseWindowController.shared.close()
                    OutputController.deliver(text: text, mode: settings.outputMode, toApp: Self.callingApp)
                }
            } catch {
                await MainActor.run {
                    ResponseWindowController.shared.showResponse("\(L10n.shared.t("error.prefix")): \(error.localizedDescription)")
                }
            }
        }
    }

    // MARK: - NSServices selectors

    @objc func serviceExplain(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .explain) }
    }

    @objc func serviceRefactor(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .refactor) }
    }

    @objc func serviceOptimize(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .optimize) }
    }

    @objc func serviceAddComments(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .addComments) }
    }

    @objc func serviceFindBugs(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .findBugs) }
    }

    @objc func serviceWriteTests(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .writeTests) }
    }

    @objc func serviceCustom(_ pboard: NSPasteboard, userData: String?, error: AutoreleasingUnsafeMutablePointer<NSString?>?) {
        Task { @MainActor in self.handleService(pasteboard: pboard, preset: .custom) }
    }
}

// MARK: - UNUserNotificationCenter delegate stub

import UserNotifications

private enum UNUserNotificationCenterDelegate {
    static func register() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in }
    }
}
