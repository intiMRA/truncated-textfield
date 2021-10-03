//
//  UITextFieldViewRepresenTable.swift
//  textfield
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation
import SwiftUI

struct UITextFieldViewRepresentable: UIViewRepresentable {
    
    class UITextFieldViewRepresentableCoordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        @Binding var wholeText: String
        var truncated = ""
        var oldSize: Int = -1
        let maxChars: Int
        let id: TextFieldIds
        let didTapReturn: (TextFieldIds) -> Void
        init(text: Binding<String>, wholeText: Binding<String>, maxChars: Int, id: TextFieldIds, didTapReturn: @escaping (TextFieldIds) -> Void) {
            self._text = text
            self.id = id
            self.maxChars = maxChars
            self._wholeText = wholeText
            self.didTapReturn = didTapReturn
        }
        
        func didChangeText(_ newText: String) {
            if newText.count > maxChars, oldSize < newText.count {
                truncated.append(contentsOf: newText.replacingOccurrences(of: "...", with: "").prefix(newText.count - oldSize))
            }
            
            var text = newText

            if text.count > maxChars, oldSize < text.count {
                text = truncateText(text: text)
            } else if text.replacingOccurrences(of: "...", with: "").count < maxChars, oldSize > text.count, !truncated.isEmpty {
                text = unTruncate(text: text)
            }
            
            oldSize = text.count
            wholeText = truncated + text.replacingOccurrences(of: "...", with: "")
            self.text = text
        }
        
        private func truncateText(text: String) -> String {
            let range = text.startIndex..<text.index(text.startIndex, offsetBy: text.count - maxChars)
            return text.replacingCharacters(in: range, with: "...")
        }

        private func unTruncate(text: String) -> String {
            var newText = text
            let startInxed = truncated.index(truncated.startIndex, offsetBy: max(truncated.count - (oldSize - newText.count), 0))
            let range = startInxed..<truncated.endIndex
            newText = String(truncated.suffix(min(truncated.count, oldSize - newText.count))) + newText.replacingOccurrences(of: "...", with: "")
            truncated = truncated.replacingCharacters(in: range, with: "")
            if !truncated.isEmpty {
                newText = "..." + newText
            }

            return newText
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.didTapReturn(self.id)
            return true
        }
        
    }
    
    @Binding var text: String
    @Binding var wholeText: String
    let maxChars: Int
    let isFoused: Bool
    let placeholder: String
    let returnKeyType: UIReturnKeyType
    let id: TextFieldIds
    let didTapReturn: (TextFieldIds) -> Void
    init(text: Binding<String>, wholeText: Binding<String>, maxChars: Int, placeholder: String, isFoused: Bool, returnKeyType: UIReturnKeyType, id: TextFieldIds, didTapReturn: @escaping (TextFieldIds) -> Void) {
        self._text = text
        self._wholeText = wholeText
        self.placeholder = placeholder
        self.isFoused = isFoused
        self.id = id
        self.maxChars = maxChars
        self.didTapReturn = didTapReturn
        self.returnKeyType = returnKeyType
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = TextfieldWithActionHandler(frame: .zero)
        textField.delegate = context.coordinator
        
        let placeholder = NSMutableAttributedString(string: self.placeholder)
        
        textField.attributedPlaceholder = placeholder
        
        if isFoused {
            textField.becomeFirstResponder()
        }
        
        textField.setupActionHandler(actionHandler: context.coordinator.didChangeText(_:))
        textField.returnKeyType = self.returnKeyType
        
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = self.text
        
        if isFoused && !uiView.isFirstResponder {
            uiView.becomeFirstResponder()
        } else  if !isFoused {
            uiView.resignFirstResponder()
        }
    }
    
    func makeCoordinator() -> UITextFieldViewRepresentableCoordinator {
        UITextFieldViewRepresentableCoordinator(text: $text, wholeText: $wholeText, maxChars: maxChars, id: self.id, didTapReturn: self.didTapReturn)
    }
}

class TextfieldWithActionHandler: UITextField {
    var actionHandler: ((String) -> Void)?
    
    func setupActionHandler(actionHandler: @escaping (String) -> Void) {
        self.actionHandler = actionHandler
        self.addTarget(self, action: #selector(triggerAction), for: .editingChanged)
    }
    
    @objc
    func triggerAction() {
        self.actionHandler?(self.text ?? "")
    }
}
