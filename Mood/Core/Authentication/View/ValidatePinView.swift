//
//  ValidatePinView.swift
//  Mood
//
//  Created by Nate Leake on 10/10/24.
//

import SwiftUI

struct ValidatePinView: View {
    @AppStorage("useBiometricsToUnlock") var useBiometricsToUnlock: Bool = false
    @Environment(\.scenePhase) var scenePhase
    @State var pinEntered: String = ""
    @State var isPinIncorrect: Bool = false
    @State var biometricsError: String = ""
    @State var biometricsWasCanceled: Bool = false
    @FocusState private var isTextFieldFocused: Bool
    
    // Check if the PIN is complete (4 digits)
    func isPinComplete() -> Bool {
        return pinEntered.count == 4
    }
    
    // Validate the entered PIN (this is where you'd handle submission logic)
    func validatePin() {
        print("Entered PIN: \(pinEntered)")  // Handle PIN validation here, or save it to the viewModel
    }
    
    private func bioAuth() {
        AuthService.shared.unlockUsingBiometrics() { result in
            switch result {
            case .success(let success):
                biometricsError = ""
            case .failure(let error):
                biometricsError = error.localizedDescription.lowercased().trimmingCharacters(in: .punctuationCharacters)
                isPinIncorrect = true
                biometricsWasCanceled = true
            }
        }
    }
    
    var body: some View {
        ZStack {
            Color.appPurple
                .ignoresSafeArea()
            
            VStack {
                RegistrationHeaderView(header: "quick unlock", subheading: "unlock mood with your pin or biometrics")
                
                VStack{
                    Text(biometricsError)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(7)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                }
                .opacity(isPinIncorrect ? 1:0)
                
                // MARK: - Single PIN Entry Field
                TextField("", text: $pinEntered,
                          prompt: Text("pin")
                    .foregroundStyle(.white.opacity(0.7))
                )
                .frame(width: 200, height: 50)
                .multilineTextAlignment(.center)
                .font(.headline)
                .keyboardType(.numberPad)
                .foregroundStyle(.white)
                .tint(.white)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white, lineWidth: 2)
                )
                .onChange(of: pinEntered) { newValue, oldValue in
                    // Limit input to 4 digits, and allow only numbers
                    pinEntered = String(newValue.prefix(4).filter { $0.isNumber })
                }
                .focused($isTextFieldFocused)  // Set focus state
                .padding(.bottom, 50)
                
                // Navigation to next screen (enabled only if PIN is complete)
                Button {
                    isTextFieldFocused = false
                    let success: Bool = AuthService.shared.unlock(using: pinEntered)
                    withAnimation(.easeInOut(duration: 0.2)){
                        biometricsError = "incorrect pin"
                        isPinIncorrect = !success
                    }
                } label: {
                    HStack {
                        Text("unlock")
                        Image(systemName: "lock.open")
                    }
                    .font(.headline)
                    .fontWeight(.bold)
                    .frame(width: 360, height: 44)
                    .foregroundStyle(.appPurple)
                    .background(isPinComplete() ? .white : .white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(!isPinComplete())  // Disable button until PIN is fully entered
                
                if useBiometricsToUnlock {
                    
                    Text("or")
                        .font(.body)
                        .foregroundStyle(Color.appPurple.isLight() ? .black : .white)
                    
                    Button {
                        bioAuth()
                    } label: {
                        HStack {
                            Text("use FaceID")
                            Image(systemName: "faceid")
                        }
                        .font(.body)
                        .fontWeight(.bold)
                        .padding(10)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                }
                
                Spacer()
            }
        }
        .onChange(of: scenePhase) { old, new in
            if new == .active {
                if useBiometricsToUnlock && !biometricsWasCanceled {
                    bioAuth()
                } else {
                    isTextFieldFocused = true  // Auto-focus the text field when the view appears
                }
            }
        }
        .onTapGesture {
            isTextFieldFocused = false  // Dismiss keyboard when tapping outside the text field
        }
    }
}

#Preview {
    ValidatePinView()
}
