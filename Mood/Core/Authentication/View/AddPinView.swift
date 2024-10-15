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
    @State var enteredPin: String = ""
    @State var pinIsValid: Bool = false
    
    // Check if the PIN is complete (4 digits)
    func isPinComplete() {
        withAnimation(.easeInOut){
            pinIsValid = enteredPin.count == 4
        }
    }
    
    var body: some View {
        ZStack {
            Color.appPurple
                .ignoresSafeArea()
            
            VStack {
                Text("create a pin")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                Text("this helps keep your data secure")
                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                // MARK: - Single PIN Entry Field
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
                    .onChange(of: enteredPin) { newValue, oldValue in
                        // Limit input to 4 digits, and allow only numbers
                        let filteredPin = String(newValue.prefix(4).filter { $0.isNumber })
                        if enteredPin != filteredPin {
                            enteredPin = filteredPin  // Update only if the filtered value is different
                            isPinComplete()
                        }
                        
                        if pinIsValid {
                            viewModel.pin = enteredPin
                        }
                    }
                    .focused($isTextFieldFocused)
                    .padding(.bottom, 50)
                
                // Navigation to next screen (enabled only if PIN is complete)
                NavigationLink() {
                    CompleteSignUpView()
                        .navigationBarBackButtonHidden()
                } label: { Text("next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(pinIsValid ? .white : .white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!pinIsValid)  // Disable button until PIN is fully entered
                
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
            // No `NavigationStack` here as it's already provided at a higher level
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
