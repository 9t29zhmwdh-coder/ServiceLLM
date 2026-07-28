import AppKit
import CoreGraphics
import UserNotifications

@MainActor
enum OutputController {
    static func deliver(
        text: String,
        mode: OutputMode,
        toApp callingApp: NSRunningApplication?
    ) {
        switch mode {
        case .popup:
            ResponseWindowController.shared.showResponse(text)
        case .clipboard:
            copyToClipboard(text)
            showBriefNotification(title: "ServiceLLM", body: L10n.shared.t("notification.copiedToClipboard"))
        case .notification:
            sendNotification(title: "ServiceLLM", body: text)
        case .pasteBack:
            Task { await pasteBack(text, to: callingApp) }
        }
    }

    static func copyToClipboard(_ text: String) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)
    }

    static func pasteBackText(_ text: String, to app: NSRunningApplication?) async {
        await pasteBack(text, to: app)
    }

    // MARK: - Private helpers

    private static func showBriefNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = String(body.prefix(200))
        let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
        UNUserNotificationCenter.current().add(req)
    }

    private static func sendNotification(title: String, body: String) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, _ in
            guard granted else { return }
            let content = UNMutableNotificationContent()
            content.title = title
            content.body = String(body.prefix(500))
            let req = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
            UNUserNotificationCenter.current().add(req)
        }
    }

    private static func pasteBack(_ text: String, to app: NSRunningApplication?) async {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(text, forType: .string)

        // Bring the calling app to front
        if let app = app {
            app.activate(options: [.activateAllWindows])
        }

        // Brief delay to let the app activate
        try? await Task.sleep(for: .milliseconds(200))

        // Send Cmd+V via CGEvent
        let src = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
        let vKey: CGKeyCode = 9  // V key

        if let keyDown = CGEvent(keyboardEventSource: src, virtualKey: vKey, keyDown: true) {
            keyDown.flags = CGEventFlags.maskCommand
            keyDown.post(tap: CGEventTapLocation.cghidEventTap)
        }
        if let keyUp = CGEvent(keyboardEventSource: src, virtualKey: vKey, keyDown: false) {
            keyUp.flags = CGEventFlags.maskCommand
            keyUp.post(tap: CGEventTapLocation.cghidEventTap)
        }
    }
}
