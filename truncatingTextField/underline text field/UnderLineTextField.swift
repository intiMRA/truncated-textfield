//
//  UnderLineTextField.swift
//  textfield
//
//  Created by Inti Albuquerque on 30/05/21.
//

import SwiftUI

struct UnderLineTextField: View {
    @Binding var text: String
    @Binding var wholeText: String
    let isFoused: Bool
    let maxChars: Int
    let placeholder: String
    let returnKeyType: UIReturnKeyType
    let id: TextFieldIds
    let didTapReturn: (TextFieldIds) -> Void
    let wasTapped: (TextFieldIds) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            UITextFieldViewRepresentable(text: $text, wholeText: $wholeText, maxChars: maxChars, placeholder: placeholder, isFoused: isFoused, returnKeyType: returnKeyType, id: id, didTapReturn: didTapReturn)
            underLine
                .frame(height: 1)
        }
        .contentShape(Rectangle())
        .frame(height: 44)
        .onTapGesture(count: 1) {
            self.wasTapped(self.id)
        }
    }
    
    @ViewBuilder
    var underLine: some View {
        if isFoused {
            Color.red
        } else {
            Color.blue
        }
    }
}
