//
//  ValidatePinView.swift
//  Mood
//
//  Created by Nate Leake on 10/10/24.
//

import SwiftUI

struct ValidatePinView: View {
    @State var pinEntered: String = ""
    @State var isPinIncorrect: Bool = false
    @FocusState private var isTextFieldFocused: Bool  // To handle text field focus state
    
    // Check if the PIN is complete (4 digits)
    func isPinComplete() -> Bool {
        return pinEntered.count == 4
    }
    
    // Validate the entered PIN (this is where you'd handle submission logic)
    func validatePin() {
        print("Entered PIN: \(pinEntered)")  // Handle PIN validation here, or save it to the viewModel
    }
    
    var body: some View {
        ZStack {
            Color.appPurple
                .ignoresSafeArea()
            
            VStack {
                Text("enter your pin")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                Text("this helps keep your data secure")
                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
                
                Text("the pin you entered is incorrect")
                    .foregroundStyle(.appRed)
                    .font(.headline)
                    .opacity(isPinIncorrect ? 1:0)
                
                // MARK: - Single PIN Entry Field
                TextField("enter 4-digit PIN", text: $pinEntered)
                    .frame(width: 200, height: 50)
                    .multilineTextAlignment(.center)
                    .font(.headline)
                    .keyboardType(.numberPad)
                    .foregroundColor(.white)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white, lineWidth: 2)
                    )
                    .onChange(of: pinEntered) { newValue, oldValue in
                        // Limit input to 4 digits, and allow only numbers
                        print("change")
                        pinEntered = String(newValue.prefix(4).filter { $0.isNumber })
                    }
                    .focused($isTextFieldFocused)  // Set focus state
                    .padding(.bottom, 50)
                
                // Navigation to next screen (enabled only if PIN is complete)
                Button {
                    isTextFieldFocused = false
                    let success: Bool = AuthService.shared.unlock(using: pinEntered)
                    withAnimation(.easeInOut(duration: 0.2)){
                        isPinIncorrect = !success
                    }
                } label: {
                    Text("unlock")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(isPinComplete() ? .white : .white.opacity(0.7))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!isPinComplete())  // Disable button until PIN is fully entered
                
                Spacer()
            }
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
    ValidatePinView()
}
