//
//  ContentView.swift
//  SuggestionFieldTest
//
//  Created by david-swift
//

import SuggestionField
import SwiftUI

struct ContentView: View {
    @State private var values: [IdentifiableString] = [.init("")]
    @FocusState private var focusedValue: UUID?
    let words = ["tiger", "this", "ice", "snake", "SuggestionField"]
    
    var body: some View {
        ScrollView{
            ForEach($values){ $value in
                ScrollView(.horizontal){
                    SuggestionField("Value", text: $value.string, divide: true, words: words)
                        .font(.system(size: 60))
                        .focused($focusedValue, equals: value.id)
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(.secondary.opacity(focusedValue == value.id ? 0.1 : 0))
                        }
                        .animation(.easeInOut, value: values)
                        .animation(.easeInOut, value: focusedValue)
                        .padding()
                }
            }
        }
        .onChange(of: values) { newValue in
            withAnimation{
                if let last = newValue.last{
                    if !last.string.isEmpty {
                        values.append(.init(""))
                    }
                }else{
                    values.append(.init(""))
                }
            }
        }
    }
}

struct IdentifiableString: Identifiable, Equatable {
    let id = UUID()
    var string: String
    
    init(_ string: String) {
        self.string = string
    }
}
