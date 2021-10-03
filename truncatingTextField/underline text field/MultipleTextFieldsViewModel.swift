//
//  MultipleTextFieldsViewModel.swift
//  textfield
//
//  Created by Inti Albuquerque on 29/05/21.
//

import Foundation

enum TextFieldIds: Int {
    case one, two, three, four
}

class MultipleTextFieldsViewModel: ObservableObject {
    @Published var text1 = ""
    @Published var text2 = ""
    @Published var text3 = ""
    @Published var text4 = ""
    
    @Published var wholeText1 = ""
    @Published var wholeText2 = ""
    @Published var wholeText3 = ""
    @Published var wholeText4 = ""
    
    @Published var text1IsFocused = false
    @Published var text2IsFocused = false
    @Published var text3IsFocused = false
    @Published var text4IsFocused = false
    
    @Published var showAlert = false
    
    func didTapReturn(_ id: TextFieldIds) {
        resetFocus()
        switch id {
        case .one:
            text2IsFocused = true
        case .two:
            text3IsFocused = true
        case .three:
            text4IsFocused = true
        case .four:
            showAlert = true
        }
        
    }
    
    func textFieldWasTapped(_ id: TextFieldIds) {
        resetFocus()
        switch id {
        case .one:
            text1IsFocused = true
        case .two:
            text2IsFocused = true
        case .three:
            text3IsFocused = true
        case .four:
            text4IsFocused = true
        }
    }
    
    func resetFocus() {
        text1IsFocused = false
        text2IsFocused = false
        text3IsFocused = false
        text4IsFocused = false
    }
}
