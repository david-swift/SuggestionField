# SuggestionField
_SuggestionField_ is a simple text field for SwiftUI with completion suggestions in the background. The user can accept the suggestions by pressing the enter key.

## Example
![](https://user-images.githubusercontent.com/106754840/178121504-2b753d7e-4c1f-41ab-98a7-35e4bda77249.mov)
<details>

<summary>Code of example</summary>

```swift
import SuggestionField
import SwiftUI
```
```swift
struct ContentView: View {
    @State private var values: [IdentifiableString] = [.init("")]
    @FocusState private var focusedValue: UUID?
    let words = ["tiger", "this", "ice", "snake", "SuggestionField"]
    
    var body: some View {
        ScrollView {
            ForEach($values) { $value in
                ScrollView(.horizontal) {
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
            withAnimation {
                if let last = newValue.last {
                    if !last.string.isEmpty {
                        values.append(.init(""))
                    }
                } else {
                    values.append(.init(""))
                }
            }
        }
    }
}
```
```swift
struct IdentifiableString: Identifiable, Equatable {
    let id = UUID()
    var string: String
    
    init(_ string: String) {
        self.string = string
    }
}
```

</details>

## Overview
Use a _SuggestionField_ when you want a text field but with suggestions for completing the input. 

### Your own algorithm
You can create your own suggestion algorithm:
```swift
struct ProgrammingLanguageField: View{
    
    @State private var programmingLanguage = "C#"
    
    var body: some View{
        SuggestionField("Programming Language", text: $programmingLanguage) { input in
            if input == "Swift"{
                return "UI"
            }else if input == "Python"{
                return " (no ... it's not a snake)"
            }else{
                return ""
            }
        }
    }
}
```

### Words
You can pass an array of strings with suggestions to the _SuggestionField_:

```swift
struct ProgrammingLanguageField: View{
    
    @State private var programmingLanguage = "C#"
    let programmingLanguages = ["C", "C#", "C++", "CSS", "HTML", "Java", "JavaScript", "Kotlin", "Objective-C", "Python", "Ruby", "Swift"]
    
    var body: some View{
        SuggestionField("Programming Language", text: $programmingLanguage, words: programmingLanguages)
    }
}

```

### Combination
You can combine the both completion methods. If your own algorithm provides a completion, this completion is used, else, one of the words in the array is used.

## Initializer

```swift
init(_ placeholder: String, text: Binding<String>, divide divideText: Bool = false, words: [String] = [], capitalized: Bool = false, autoComplete: @escaping (String) -> String = { _ in return "" })
```
### Placeholder
The placeholder (\__: String_) is a string that is showed when the user's input is empty.

### Text
The text (_text: Binding\<String\>_) stores the user's input.

### Divide
If divide (_divide: Bool_) is _true_, the suggestions are displayed after every single word.

### Words
The words (_words: [String]_) is an array of strings with all the autocompletion suggestions.

### Capitalized
The capitalized bool (_capitalized: Bool_) defines, if capital letters matter or if the suggestion is made without the correct capitalization as well.

### AutoComplete
AutoComplete (_autoComplete: @escaping (String) -> String_) is the function called when the user changes the input to update the completion suggestion. The parameter is the user's active input (if _divide_ is _true_, it is the last word, else, it is the whole input) and the return value is the new completion suggestion. If there is no suggestion, it should be an empty string.

