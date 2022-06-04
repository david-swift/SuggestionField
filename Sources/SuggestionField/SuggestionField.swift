import SwiftUI

public struct SuggestionField: View {
    
    @Binding private var text: String
    @FocusState private var focused: Bool
    private var placeholder: String
    private var autoComplete: (String) -> String
    private var divideText: Bool
    
    public init(_ placeholder: String, text: Binding<String>, divide divideText: Bool = false, autoComplete: @escaping (String) -> String){
        self.placeholder = placeholder
        self._text = text
        self.divideText = divideText
        self.autoComplete = autoComplete
    }
    
    public init(_ placeholder: String, text: Binding<String>, divide divideText: Bool = false, words: [String], capitalized: Bool = false){
        self.placeholder = placeholder
        self._text = text
        self.divideText = divideText
        autoComplete = { input in
            if input.isEmpty{
                return ""
            }
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
        }
    }
    
    public var body: some View {
        ZStack{
            if focused{
                if divideText{
                    TextField(text + autoComplete(lastWord(of: text)), text: .constant(""))
                        .textFieldStyle(.plain)
                        .disabled(true)
                }else{
                    TextField(text + autoComplete(text), text: .constant(""))
                        .textFieldStyle(.plain)
                        .disabled(true)
                }
            }
            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .focused($focused)
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
