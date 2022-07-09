import SwiftUI
import XCTest
@testable import SuggestionField

final class SuggestionFieldTests: XCTestCase {
    func testSuggestionField() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        @State var text = ""
        let _ = SuggestionField("Hello", text: $text, divide: true, capitalized: false)
    }
}
