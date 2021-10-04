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
    @Binding var showTruncation: Bool
    let isFoused: Bool
    let maxChars: Int
    let placeholder: String
    let returnKeyType: UIReturnKeyType
    let id: TextFieldIds
    let didTapReturn: (TextFieldIds) -> Void
    let wasTapped: (TextFieldIds) -> Void
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 0) {
                if showTruncation {
                    Text("...")
                        .padding(.trailing, 0)
                }
                UITextFieldViewRepresentable(text: $text, wholeText: $wholeText, showTrancation: $showTruncation, maxChars: maxChars, placeholder: placeholder, isFoused: isFoused, returnKeyType: returnKeyType, id: id, didTapReturn: didTapReturn)
                    .padding(.leading, 0)
            }
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
