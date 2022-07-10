//
//  SuggestionFieldTests.swift
//  SuggestionField
//
//  Created by david-swift
//

import SwiftUI
import XCTest
@testable import SuggestionField

final class SuggestionFieldTests: XCTestCase {
    func testSuggestionField() {
        @State var text = ""
        let _ = SuggestionField("Hello", text: $text, divide: true, capitalized: false)
    }
}
