import XCTest
@testable import ServiceLLM

final class ResponseFormatterTests: XCTestCase {

    func testFormatTrimsLeadingWhitespace() {
        let input = "   Hello world"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Hello world")
    }

    func testFormatTrimsTrailingWhitespace() {
        let input = "Hello world   \n\n"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Hello world")
    }

    func testFormatCollapsesTripleNewlines() {
        let input = "Line 1\n\n\nLine 2"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Line 1\n\nLine 2")
    }

    func testFormatCollapsesMultipleTripleNewlines() {
        let input = "Line 1\n\n\n\n\nLine 2"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Line 1\n\nLine 2")
    }

    func testFormatPreservesDoubleNewlines() {
        let input = "Line 1\n\nLine 2"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Line 1\n\nLine 2")
    }

    func testFormatPreservesSingleNewlines() {
        let input = "Line 1\nLine 2"
        let result = ResponseFormatter.format(input)
        XCTAssertEqual(result, "Line 1\nLine 2")
    }

    func testFormatHandlesEmpty() {
        let result = ResponseFormatter.format("")
        XCTAssertEqual(result, "")
    }

    func testFormatHandlesOnlyWhitespace() {
        let result = ResponseFormatter.format("   \n\n   ")
        XCTAssertEqual(result, "")
    }

    func testExtractCodeBlockSimple() {
        let input = "Here is code:\n```swift\nlet x = 5\n```\nEnd"
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertEqual(extracted, "let x = 5")
    }

    func testExtractCodeBlockWithLanguage() {
        let input = "```python\ndef hello():\n    print('hi')\n```"
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertEqual(extracted, "def hello():\n    print('hi')")
    }

    func testExtractCodeBlockNoLanguage() {
        let input = "```\nplain code\n```"
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertEqual(extracted, "plain code")
    }

    func testExtractCodeBlockNotFound() {
        let input = "No code here"
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertNil(extracted)
    }

    func testExtractCodeBlockMultiline() {
        let input = """
        ```swift
        func test() {
            let a = 1
            let b = 2
            return a + b
        }
        ```
        """
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertNotNil(extracted)
        XCTAssertTrue(extracted?.contains("func test") ?? false)
    }

    func testExtractCodeBlockOnlyFirst() {
        let input = """
        ```\ncode1\n```
        text
        ```\ncode2\n```
        """
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertEqual(extracted, "code1")
    }

    func testExtractCodeBlockWithSpecialChars() {
        let input = "```javascript\nconst x = 'hello\\nworld';\n```"
        let extracted = ResponseFormatter.extractCodeBlock(input)
        XCTAssertNotNil(extracted)
    }

    func testIsCodeResponseWithCodeBlock() {
        let input = "Here is the solution:\n```swift\nlet x = 5\n```"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithFuncKeyword() {
        let input = "func hello() { print('hi') }"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithClassKeyword() {
        let input = "class MyClass { }"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithStructKeyword() {
        let input = "struct MyStruct { var x: Int }"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithImportKeyword() {
        let input = "import Foundation"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithPythonDef() {
        let input = "def hello():\n    return 42"
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertTrue(isCode)
    }

    func testIsCodeResponseWithPlainText() {
        let input = "This is a plain English explanation of the code."
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertFalse(isCode)
    }

    func testIsCodeResponseEdgeCase() {
        let input = "I explained the function for you."
        let isCode = ResponseFormatter.isCodeResponse(input)
        XCTAssertFalse(isCode)
    }
}
