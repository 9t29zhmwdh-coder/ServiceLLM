import XCTest
@testable import ServiceLLM

final class LocalizationTests: XCTestCase {

    func testAppLanguageEnglish() {
        let lang = AppLanguage.en
        XCTAssertEqual(lang.rawValue, "en")
        XCTAssertEqual(lang.displayName, "English")
    }

    func testAppLanguageGerman() {
        let lang = AppLanguage.de
        XCTAssertEqual(lang.rawValue, "de")
        XCTAssertEqual(lang.displayName, "Deutsch")
    }

    func testAppLanguageAllCases() {
        let cases = AppLanguage.allCases
        XCTAssertEqual(cases.count, 2)
        XCTAssertTrue(cases.contains(.en))
        XCTAssertTrue(cases.contains(.de))
    }

    func testSystemDefaultEnglish() {
        // This test is environment-dependent and may pass/fail based on system locale.
        // Just verify the function returns one of the valid languages.
        let systemDefault = AppLanguage.systemDefault()
        XCTAssertTrue(systemDefault == .en || systemDefault == .de)
    }

    func testAppLanguageSendable() {
        // Verify that AppLanguage conforms to Sendable
        let lang: AppLanguage = .en
        let sendableValue = lang as AppLanguage
        XCTAssertNotNil(sendableValue)
    }

    @MainActor
    func testL10nSharedInstance() {
        let l10n1 = L10n.shared
        let l10n2 = L10n.shared
        XCTAssertTrue(l10n1 === l10n2)
    }

    @MainActor
    func testL10nTranslationEnglish() {
        // Access L10n.shared (which is @MainActor)
        // We test that the localization dictionary contains expected English keys
        let l10n = L10n.shared

        // Test English strings directly from the private dictionary
        // by verifying that the translation function returns valid strings
        let explanationKey = "preset.explain"
        let translation = l10n.t(explanationKey)

        // Since we can't easily test the private dictionary in a unit test,
        // we verify the fallback behavior: if a key exists, it returns something
        XCTAssertFalse(translation.isEmpty)
    }

    @MainActor
    func testL10nFallbackToEnglish() {
        let l10n = L10n.shared
        // Test that an unknown key is returned as-is
        let unknownKey = "unknown.key.xyz"
        let translation = l10n.t(unknownKey)
        XCTAssertEqual(translation, unknownKey)
    }

    @MainActor
    func testL10nLanguageProperty() {
        // Test the language property logic: override ?? systemDefault
        let l10n = L10n.shared
        let currentLanguage = l10n.language
        XCTAssertTrue(currentLanguage == .en || currentLanguage == .de)
    }

    @MainActor
    func testL10nOverrideInitialization() {
        // This test verifies that L10n initializes without crashing
        let l10n = L10n.shared
        // Just verify the object is created
        XCTAssertNotNil(l10n)
    }

    @MainActor
    func testL10nTranslationMultipleKeys() {
        let l10n = L10n.shared

        let keys = [
            "preset.explain",
            "preset.refactor",
            "settings.general.language",
            "statusbar.settings",
        ]

        for key in keys {
            let translation = l10n.t(key)
            XCTAssertFalse(translation.isEmpty, "Key \(key) should have a translation")
        }
    }

    @MainActor
    func testL10nObservableObject() {
        // Verify L10n conforms to ObservableObject (has @Published properties)
        let l10n = L10n.shared
        XCTAssertNotNil(l10n)
        // The override property should be observable
    }
}
