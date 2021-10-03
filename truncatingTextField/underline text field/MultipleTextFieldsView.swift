//
//  MultipleTextFields.swift
//  textfield
//
//  Created by Inti Albuquerque on 29/05/21.
//

import SwiftUI

struct MultipleTextFieldsView: View {
    @ObservedObject var viewModel = MultipleTextFieldsViewModel()
    let maxChars = 10
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                UnderLineTextField(text: $viewModel.text1, wholeText: $viewModel.wholeText1, isFoused: viewModel.text1IsFocused, maxChars: maxChars, placeholder: "First name", returnKeyType: .next, id: .one, didTapReturn: viewModel.didTapReturn(_:), wasTapped: viewModel.textFieldWasTapped(_:))
               
                UnderLineTextField(text: $viewModel.text2, wholeText: $viewModel.wholeText2, isFoused: viewModel.text2IsFocused, maxChars: maxChars, placeholder: "Last name", returnKeyType: .next, id: .two, didTapReturn: viewModel.didTapReturn(_:), wasTapped: viewModel.textFieldWasTapped(_:))
                    
                UnderLineTextField(text: $viewModel.text3, wholeText: $viewModel.wholeText3, isFoused: viewModel.text3IsFocused, maxChars: maxChars, placeholder: "Favorite food", returnKeyType: .next, id: .three, didTapReturn: viewModel.didTapReturn(_:), wasTapped: viewModel.textFieldWasTapped(_:))
                    
                UnderLineTextField(text: $viewModel.text4, wholeText: $viewModel.wholeText4, isFoused: viewModel.text4IsFocused, maxChars: maxChars, placeholder: "Favorite animal", returnKeyType: .done, id: .four, didTapReturn: viewModel.didTapReturn(_:), wasTapped: viewModel.textFieldWasTapped(_:))
                
                Button(action: {viewModel.showAlert = true}, label: {
                    Text("showText")
                })
                    
            }
            .padding()
        }
        .alert(isPresented: $viewModel.showAlert) {
            Alert(title: Text("Done"), message: Text(viewModel.wholeText1), dismissButton: .default(Text("Ok")))
                }
    }
}

struct MultipleTextFields_Previews: PreviewProvider {
    static var previews: some View {
        MultipleTextFieldsView()
    }
}
