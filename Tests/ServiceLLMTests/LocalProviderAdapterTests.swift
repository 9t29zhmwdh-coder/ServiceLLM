import XCTest
import EmissaryKit
@testable import ServiceLLM

final class LocalProviderAdapterTests: XCTestCase {

    func testChatMessageRoleMapping() {
        let system = ChatMessage.system("be helpful").asEmissaryKitMessage()
        let user = ChatMessage.user("explain this").asEmissaryKitMessage()
        let assistant = ChatMessage.assistant("sure").asEmissaryKitMessage()

        XCTAssertEqual(system.role, .system)
        XCTAssertEqual(system.content, "be helpful")
        XCTAssertEqual(user.role, .user)
        XCTAssertEqual(assistant.role, .assistant)
    }

    func testEmissaryKitErrorMapping() {
        let httpError = EmissaryKit.LLMError.httpError(statusCode: 500, body: "boom").asServiceLLMError()
        guard case .httpError(let code, let body) = httpError else {
            return XCTFail("Expected .httpError")
        }
        XCTAssertEqual(code, 500)
        XCTAssertEqual(body, "boom")

        guard case .providerError(let message) = EmissaryKit.LLMError.cancelled.asServiceLLMError() else {
            return XCTFail("Expected .providerError for cancelled")
        }
        XCTAssertEqual(message, "Request cancelled")
    }
}
