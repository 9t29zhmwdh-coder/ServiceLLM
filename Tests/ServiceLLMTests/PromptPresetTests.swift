import XCTest
@testable import ServiceLLM

final class PromptPresetTests: XCTestCase {

    func testAllPresetsHaveSystemPrompt() {
        for preset in PromptPreset.allCases {
            let systemPrompt = preset.systemPrompt
            // Custom preset allows empty, others should have content
            if preset != .custom {
                XCTAssertFalse(systemPrompt.isEmpty, "Preset \(preset) should have non-empty system prompt")
            }
        }
    }

    func testExplainPreset() {
        let preset = PromptPreset.explain
        XCTAssertEqual(preset.rawValue, "Explain")
        XCTAssertFalse(preset.systemPrompt.isEmpty)
        XCTAssertTrue(preset.systemPrompt.contains("code explainer"))
        XCTAssertEqual(preset.displayIcon, "💡")
        XCTAssertEqual(preset.localizationKey, "preset.explain")
    }

    func testRefactorPreset() {
        let preset = PromptPreset.refactor
        XCTAssertEqual(preset.rawValue, "Refactor")
        XCTAssertTrue(preset.systemPrompt.contains("refactoring expert"))
        XCTAssertEqual(preset.displayIcon, "🔧")
        XCTAssertEqual(preset.localizationKey, "preset.refactor")
    }

    func testOptimizePreset() {
        let preset = PromptPreset.optimize
        XCTAssertEqual(preset.rawValue, "Optimize")
        XCTAssertTrue(preset.systemPrompt.contains("performance optimization"))
        XCTAssertEqual(preset.displayIcon, "⚡")
        XCTAssertEqual(preset.localizationKey, "preset.optimize")
    }

    func testAddCommentsPreset() {
        let preset = PromptPreset.addComments
        XCTAssertEqual(preset.rawValue, "Add Comments")
        XCTAssertTrue(preset.systemPrompt.contains("documentation comments"))
        XCTAssertEqual(preset.displayIcon, "📝")
        XCTAssertEqual(preset.localizationKey, "preset.addComments")
    }

    func testFindBugsPreset() {
        let preset = PromptPreset.findBugs
        XCTAssertEqual(preset.rawValue, "Find Bugs")
        XCTAssertTrue(preset.systemPrompt.contains("code reviewer"))
        XCTAssertEqual(preset.displayIcon, "🐛")
        XCTAssertEqual(preset.localizationKey, "preset.findBugs")
    }

    func testWriteTestsPreset() {
        let preset = PromptPreset.writeTests
        XCTAssertEqual(preset.rawValue, "Write Tests")
        XCTAssertTrue(preset.systemPrompt.contains("unit tests"))
        XCTAssertEqual(preset.displayIcon, "🧪")
        XCTAssertEqual(preset.localizationKey, "preset.writeTests")
    }

    func testCustomPreset() {
        let preset = PromptPreset.custom
        XCTAssertEqual(preset.rawValue, "Custom")
        XCTAssertTrue(preset.systemPrompt.isEmpty)
        XCTAssertEqual(preset.displayIcon, "✨")
        XCTAssertEqual(preset.localizationKey, "preset.custom")
    }

    func testAllPresetsHaveUniqueLocalizationKeys() {
        let keys = PromptPreset.allCases.map { $0.localizationKey }
        let uniqueKeys = Set(keys)
        XCTAssertEqual(keys.count, uniqueKeys.count, "All localization keys should be unique")
    }

    func testAllPresetsHaveUniqueDisplayIcons() {
        let icons = PromptPreset.allCases.map { $0.displayIcon }
        let uniqueIcons = Set(icons)
        XCTAssertEqual(icons.count, uniqueIcons.count, "All display icons should be unique")
    }

    func testCustomPresetStruct() {
        let customPreset = CustomPreset(name: "MyPreset", systemPrompt: "Custom prompt text")
        XCTAssertEqual(customPreset.name, "MyPreset")
        XCTAssertEqual(customPreset.systemPrompt, "Custom prompt text")
        XCTAssertNotNil(customPreset.id)
    }

    func testCustomPresetCodable() {
        let customPreset = CustomPreset(name: "Codable", systemPrompt: "Test encoding")

        let encoder = JSONEncoder()
        let encoded = try? encoder.encode(customPreset)
        XCTAssertNotNil(encoded)

        if let encoded = encoded {
            let decoder = JSONDecoder()
            let decoded = try? decoder.decode(CustomPreset.self, from: encoded)
            XCTAssertNotNil(decoded)
            XCTAssertEqual(decoded?.name, "Codable")
            XCTAssertEqual(decoded?.systemPrompt, "Test encoding")
        }
    }
}
