//
//  AddPinView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/24.
//

import SwiftUI

struct AddPinView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @FocusState private var isTextFieldFocused: Bool
    @State private var enteredPin: String = ""
    @State private var pinIsValid: Bool = false
    @State private var showErrorMessage: Bool = false
    @State private var path: NavigationPath = NavigationPath()
    @State private var errorMessage: String = ""
    
    // Check if the PIN is complete (4 digits)
    func validatePin() {
        print("pin validation")
        
        print("check pin length")
        if enteredPin.count != 4 {
            errorMessage = "pin must be 4 digits"
            pinIsValid = false
            return
        }
        
        print("check pin charageters")
        let filteredPin = String(enteredPin.prefix(4).filter { $0.isNumber })
        if filteredPin.count < 4 {
            errorMessage = "pin can only contain numbers"
            pinIsValid = false
            return
        }
        
        print("pin is valid")
        
        viewModel.pin = enteredPin
        pinIsValid = true
    }
    
    var body: some View {
        ZStack {
            Color.appPurple
                .ignoresSafeArea()
            
            VStack {
                RegistrationHeaderView(header: "create a pin", subheading: "this helps keep your data secure")
                // MARK: - Single PIN Entry Field
                
                VStack{
                    Text(errorMessage)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(7)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .opacity(showErrorMessage ? 1:0)
                
                TextField("enter 4-digit PIN", text: $enteredPin)
                    .frame(width: 200, height: 50)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .focused($isTextFieldFocused)
                    .padding(.bottom, 50)
                    .onChange(of: enteredPin) { oldValue, newValue in
                        // Limit to 4 characters
                        if newValue.count > 4 {
                            enteredPin = String(newValue.prefix(4))
                        }
                    }
                
                Button(){
                    validatePin()
                    showErrorMessage = !pinIsValid
                } label: {
                    Text("next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .imageScale(.large)
                        .onTapGesture {
                            dismiss()  // Dismiss view
                        }
                }
            }

        }
        .navigationDestination(isPresented: $pinIsValid) {
            CompleteSignUpView()
                .navigationBarBackButtonHidden()
                .environmentObject(viewModel)
        }
        .onAppear {
            isTextFieldFocused = true  // Auto-focus the text field when the view appears
        }
        .onTapGesture {
            isTextFieldFocused = false  // Dismiss keyboard when tapping outside the text field
        }
    }
}

#Preview {
    AddPinView()
        .environmentObject(RegistrationViewModel())
}
