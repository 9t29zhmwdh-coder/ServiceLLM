import Foundation

enum OutputMode: String, CaseIterable, Codable, Sendable {
    case popup       = "Popup Window"
    case clipboard   = "Copy to Clipboard"
    case notification = "macOS Notification"
    case pasteBack   = "Paste Back into Editor"

    /// Localization key for L10n.t(_:); resolve at a @MainActor call site, not here,
    /// so this enum can stay Sendable and rawValue stays stable for UserDefaults persistence.
    var localizationKey: String {
        switch self {
        case .popup:        return "outputMode.popup"
        case .clipboard:     return "outputMode.clipboard"
        case .notification:  return "outputMode.notification"
        case .pasteBack:     return "outputMode.pasteBack"
        }
    }
}
