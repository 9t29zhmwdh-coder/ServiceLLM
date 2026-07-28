import Foundation

enum ResponseFormatter {
    /// Lightly clean the raw AI response for display.
    /// Strips leading/trailing whitespace and excessively repeated blank lines.
    static func format(_ raw: String) -> String {
        var result = raw.trimmingCharacters(in: .whitespacesAndNewlines)

        // Collapse 3+ consecutive blank lines into 2
        while result.contains("\n\n\n") {
            result = result.replacingOccurrences(of: "\n\n\n", with: "\n\n")
        }

        return result
    }

    /// Extract the first fenced code block from the response, if present.
    /// Returns nil if no code block is found.
    static func extractCodeBlock(_ text: String) -> String? {
        let pattern = "```(?:\\w+)?\\n([\\s\\S]*?)\\n```"
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return nil }
        let range = NSRange(text.startIndex..., in: text)
        if let match = regex.firstMatch(in: text, range: range),
           let codeRange = Range(match.range(at: 1), in: text) {
            return String(text[codeRange])
        }
        return nil
    }

    /// Returns true if the response appears to be primarily code.
    static func isCodeResponse(_ text: String) -> Bool {
        text.contains("```") || text.hasPrefix("func ") || text.hasPrefix("class ") ||
        text.hasPrefix("struct ") || text.hasPrefix("import ") || text.hasPrefix("def ")
    }
}
