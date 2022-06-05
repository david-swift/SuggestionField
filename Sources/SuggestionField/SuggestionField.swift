import SwiftUI

/// A simple text field for SwiftUI with completion suggestions in the background.
///
/// You can create your own suggestion algorithm.
///```swift
///struct ProgrammingLanguageField: View{
///    @State private var programmingLanguage = "C#"
///    var body: some View{
///        SuggestionField("Programming Language", text: $programmingLanguage) { input in
///            if input == "Swift"{
///                return "UI"
///            }else if input == "Python"{
///                return " (no ... it's not a snake)"
///            }else{
///                return ""
///            }
///        }
///    }
///}
///```
///You can pass an array of suggestions as strings.
///```swift
///struct ProgrammingLanguageField: View{
///    @State private var programmingLanguage = "C#"
///    let programmingLanguages = ["C", "C#", "C++", "CSS", "HTML", "Java", "JavaScript", "Kotlin", "Objective-C", "Python", "Ruby", "Swift"]
///    var body: some View{
///        SuggestionField("Programming Language", text: $programmingLanguage, words: programmingLanguages)
///    }
///}
///```
///Or you can combine both methods.
///```swift
///struct ProgrammingLanguageField: View{
///    @State private var programmingLanguage = "C#"
///    let programmingLanguages = ["C", "C#", "C++", "CSS", "HTML", "Java", "JavaScript", "Kotlin", "Objective-C", "Python", "Ruby", "Swift"]
///    var body: some View{
///        SuggestionField("Programming Language", text: $programmingLanguage, divide: true, words: programmingLanguages){ input in
///           if input == "Swift"{
///                return "UI"
///            }else if input == "Python"{
///                return " (no ... it's not a snake)"
///            }else{
///                return ""
///            }
///        }
///    }
///}
///```
public struct SuggestionField: View {
    
    @Environment(\.font) var font
    @Environment(\.disableAutocorrection) var disableAutocorrection
    @Binding private var text: String
    @FocusState private var focused: Bool
    private var placeholder: String
    private var autoComplete: (String) -> String
    private var divideText: Bool

    public init(_ placeholder: String, text: Binding<String>, divide divideText: Bool = false, words: [String] = [], capitalized: Bool = false, autoComplete: @escaping (String) -> String = { _ in return "" }){
        self.placeholder = placeholder
        self._text = text
        self.divideText = divideText
        self.autoComplete = { input in
            if input.isEmpty{
                return ""
            }
            let completion = autoComplete(input)
            if completion.isEmpty{
                for word in words {
                    if capitalized{
                        if ((capitalized && word.hasPrefix(input)) || (!capitalized && word.lowercased().hasPrefix(input.lowercased())))  && word.count > input.count{
                            return String(word.suffix(word.count - input.count))
                        }
                    }else{
                        if word.lowercased().hasPrefix(input.lowercased()) && word.count > input.count{
                            return String(word.suffix(word.count - input.count))
                        }
                    }
                }
                return ""
            }else{
                return completion
            }
        }
    }
    
    public var body: some View {
        ZStack{
            Group{
                if divideText{
                    TextField(text + autoComplete(lastWord(of: text)), text: .constant(""))
                        .textFieldStyle(.plain)
                        .font(font)
                        .disabled(true)
                }else{
                    TextField(text + autoComplete(text), text: .constant(""))
                        .textFieldStyle(.plain)
                        .font(font)
                        .disabled(true)
                }
            }
            .opacity(focused ? 1 : 0)
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(font)
                .focused($focused)
                .disableAutocorrection(disableAutocorrection)
                .onSubmit {
                    if divideText{
                        let lastWord = lastWord(of: text)
                        text += autoComplete(lastWord)
                    }else{
                        text += autoComplete(text)
                    }
                }
        }
    }
    
    private func lastWord(of str: String) -> String{
        let size = str.reversed().firstIndex(of: " ") ?? str.count
        let startWord = str.index(str.endIndex, offsetBy: -size)
        return String(str[startWord...])
    }
}
