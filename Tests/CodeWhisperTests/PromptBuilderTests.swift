import XCTest
@testable import CodeWhisper

final class PromptBuilderTests: XCTestCase {

    func testBuildWithPreset() {
        let code = "let x = 5"
        let messages = PromptBuilder.build(preset: .explain, code: code)

        XCTAssertEqual(messages.count, 2)
        XCTAssertEqual(messages[0].role, .system)
        XCTAssertEqual(messages[1].role, .user)
        XCTAssertEqual(messages[1].content, code)
        XCTAssertTrue(messages[0].content.contains("code explainer"))
    }

    func testBuildWithCustomPresetNoCustomPrompt() {
        let code = "func test() {}"
        let messages = PromptBuilder.build(preset: .custom, code: code, customPrompt: nil)

        XCTAssertEqual(messages.count, 2)
        XCTAssertEqual(messages[0].role, .system)
        XCTAssertEqual(messages[0].content, "")
        XCTAssertEqual(messages[1].role, .user)
        XCTAssertEqual(messages[1].content, code)
    }

    func testBuildWithCustomPresetAndCustomPrompt() {
        let code = "let x = 5"
        let customPrompt = "Explain this code in detail"
        let messages = PromptBuilder.build(preset: .custom, code: code, customPrompt: customPrompt)

        XCTAssertEqual(messages.count, 2)
        XCTAssertEqual(messages[0].role, .system)
        XCTAssertEqual(messages[0].content, customPrompt)
        XCTAssertEqual(messages[1].role, .user)
        XCTAssertEqual(messages[1].content, code)
    }

    func testBuildWithSystemPromptDirectly() {
        let systemPrompt = "You are a helpful assistant"
        let code = "print('hello')"
        let messages = PromptBuilder.build(systemPrompt: systemPrompt, code: code)

        XCTAssertEqual(messages.count, 2)
        XCTAssertEqual(messages[0].role, .system)
        XCTAssertEqual(messages[0].content, systemPrompt)
        XCTAssertEqual(messages[1].role, .user)
        XCTAssertEqual(messages[1].content, code)
    }

    func testBuildPreservesCodeExactly() {
        let code = """
        func hello() {
            print("world")
        }
        """
        let messages = PromptBuilder.build(preset: .refactor, code: code)
        XCTAssertEqual(messages[1].content, code)
    }

    func testBuildWithEmptyCode() {
        let messages = PromptBuilder.build(preset: .explain, code: "")
        XCTAssertEqual(messages[1].content, "")
    }

    func testBuildWithMultilineCustomPrompt() {
        let systemPrompt = "Line 1\nLine 2\nLine 3"
        let code = "code"
        let messages = PromptBuilder.build(systemPrompt: systemPrompt, code: code)

        XCTAssertEqual(messages[0].content, systemPrompt)
    }

    func testBuildDefaultsToEnglishWithNoLanguageSuffix() {
        let messages = PromptBuilder.build(preset: .explain, code: "let x = 5")
        XCTAssertFalse(messages[0].content.contains("Respond in German"))
    }

    func testBuildAppendsGermanInstructionForGermanLanguage() {
        let messages = PromptBuilder.build(preset: .explain, code: "let x = 5", language: .de)
        XCTAssertTrue(messages[0].content.contains("Respond in German"))
    }

    func testBuildWithRefactorPreset() {
        let code = "x=5+3"
        let messages = PromptBuilder.build(preset: .refactor, code: code)

        XCTAssertEqual(messages.count, 2)
        XCTAssertTrue(messages[0].content.contains("refactoring expert"))
    }

    func testBuildWithOptimizePreset() {
        let code = "for i in 0..<10 { print(i) }"
        let messages = PromptBuilder.build(preset: .optimize, code: code)

        XCTAssertEqual(messages.count, 2)
        XCTAssertTrue(messages[0].content.contains("performance optimization"))
    }
}
