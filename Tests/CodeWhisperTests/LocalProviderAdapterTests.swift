import XCTest
import SwiftAgent
@testable import CodeWhisper

final class LocalProviderAdapterTests: XCTestCase {

    func testChatMessageRoleMapping() {
        let system = ChatMessage.system("be helpful").asSwiftAgentMessage()
        let user = ChatMessage.user("explain this").asSwiftAgentMessage()
        let assistant = ChatMessage.assistant("sure").asSwiftAgentMessage()

        XCTAssertEqual(system.role, .system)
        XCTAssertEqual(system.content, "be helpful")
        XCTAssertEqual(user.role, .user)
        XCTAssertEqual(assistant.role, .assistant)
    }

    func testSwiftAgentErrorMapping() {
        let httpError = SwiftAgent.LLMError.httpError(statusCode: 500, body: "boom").asCodeWhisperError()
        guard case .httpError(let code, let body) = httpError else {
            return XCTFail("Expected .httpError")
        }
        XCTAssertEqual(code, 500)
        XCTAssertEqual(body, "boom")

        guard case .providerError(let message) = SwiftAgent.LLMError.cancelled.asCodeWhisperError() else {
            return XCTFail("Expected .providerError for cancelled")
        }
        XCTAssertEqual(message, "Request cancelled")
    }
}
