import AppKit
import SwiftUI

@MainActor
final class ResponseWindowController {
    static let shared = ResponseWindowController()

    private var panel: NSPanel?
    private var currentTask: Task<Void, Never>?

    private init() {}

    func showLoading(preset: String, cancelAction: @escaping () -> Void) {
        let view = LoadingPopupView(preset: preset, onCancel: cancelAction)
        present(NSHostingView(rootView: view), size: CGSize(width: 300, height: 160))
    }

    func showResponse(_ text: String) {
        let view = ResponsePopupView(
            text: text,
            onCopy: {
                OutputController.copyToClipboard(text)
            },
            onPasteBack: { [weak self] in
                self?.close()
                Task { @MainActor in
                    let callingApp = AppDelegate.callingApp
                    await OutputController.pasteBackText(text, to: callingApp)
                }
            },
            onClose: { [weak self] in self?.close() }
        )
        present(NSHostingView(rootView: view), size: CGSize(width: 560, height: 400))
    }

    func close() {
        panel?.close()
        panel = nil
    }

    private func present(_ contentView: NSView, size: CGSize) {
        panel?.close()

        let p = NSPanel(
            contentRect: NSRect(origin: .zero, size: size),
            styleMask: [.titled, .closable, .resizable, .nonactivatingPanel, .hudWindow],
            backing: .buffered,
            defer: false
        )
        p.title = "ServiceLLM"
        p.contentView = contentView
        p.isFloatingPanel = true
        p.level = .floating
        p.center()
        p.makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)

        // Escape to close
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { [weak p] event in
            if event.keyCode == 53 { // Escape
                p?.close()
                return nil
            }
            return event
        }

        panel = p
    }
}
