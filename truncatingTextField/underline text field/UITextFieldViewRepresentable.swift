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
        @Binding var showTruncation: Bool
        var hiddenCharacters = ""
        var oldSize: Int = -1
        let maxChars: Int
        let id: TextFieldIds
        let didTapReturn: (TextFieldIds) -> Void
        init(text: Binding<String>, wholeText: Binding<String>, showTruncation: Binding<Bool>, maxChars: Int, id: TextFieldIds, didTapReturn: @escaping (TextFieldIds) -> Void) {
            self._text = text
            self.id = id
            self.maxChars = maxChars
            self._wholeText = wholeText
            self._showTruncation = showTruncation
            self.didTapReturn = didTapReturn
        }
        
        func didChangeText(_ newText: String) {
            var text = newText
            if text.count > maxChars, oldSize < text.count {
                hiddenCharacters.append(contentsOf: text.prefix(text.count - oldSize))
            }

            if text.count > maxChars, oldSize < text.count {
                text = truncateText(text: text)
            } else if text.count < maxChars, oldSize > text.count, !hiddenCharacters.isEmpty {
                text = unTruncate(text: text)
            }
            
            oldSize = text.count
            wholeText = hiddenCharacters + text
            self.text = text
        }
        
        private func truncateText(text: String) -> String {
            let range = text.startIndex..<text.index(text.startIndex, offsetBy: text.count - maxChars)
            showTruncation = true
            return text.replacingCharacters(in: range, with: "")
        }

        private func unTruncate(text: String) -> String {
            var newText = text
            let startInxed = hiddenCharacters.index(hiddenCharacters.startIndex, offsetBy: max(hiddenCharacters.count - (oldSize - newText.count), 0))
            let range = startInxed..<hiddenCharacters.endIndex
            newText = String(hiddenCharacters.suffix(min(hiddenCharacters.count, oldSize - newText.count))) + newText
            hiddenCharacters = hiddenCharacters.replacingCharacters(in: range, with: "")
            if !hiddenCharacters.isEmpty {
                showTruncation = true
            } else {
                showTruncation = false
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
    @Binding var showTrancation: Bool
    let maxChars: Int
    let isFoused: Bool
    let placeholder: String
    let returnKeyType: UIReturnKeyType
    let id: TextFieldIds
    let didTapReturn: (TextFieldIds) -> Void
    init(text: Binding<String>, wholeText: Binding<String>, showTrancation: Binding<Bool>, maxChars: Int, placeholder: String, isFoused: Bool, returnKeyType: UIReturnKeyType, id: TextFieldIds, didTapReturn: @escaping (TextFieldIds) -> Void) {
        self._text = text
        self._wholeText = wholeText
        self.placeholder = placeholder
        self.isFoused = isFoused
        self.id = id
        self.maxChars = maxChars
        self.didTapReturn = didTapReturn
        self.returnKeyType = returnKeyType
        self._showTrancation = showTrancation
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
        UITextFieldViewRepresentableCoordinator(text: $text, wholeText: $wholeText, showTruncation: $showTrancation, maxChars: maxChars, id: self.id, didTapReturn: self.didTapReturn)
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
