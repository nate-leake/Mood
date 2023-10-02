//
//  SignUpView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct AddEmailView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    @State private var isFormValid: Bool = false
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: viewModel.email)
    }
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
                        
            VStack{
                Text("add your email")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("you'll use this to sign in")
                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                
                
                TextField("", text: $viewModel.email, prompt: Text("email").foregroundStyle(.gray))
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                    .padding(.vertical)
                    .keyboardType(.emailAddress)
                    .onChange(of: viewModel.email) {
                        self.isFormValid = isValidEmail()
                    }
                    
                    
                
                NavigationLink{
                    CreatePasswordView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    
                        .overlay {
                            RoundedRectangle(cornerRadius: 8)
                                .foregroundStyle(isFormValid ? .black.opacity(0.0) : .black.opacity(0.2))
                                .animation(.easeInOut(duration: 0.25), value: isFormValid)
                        }
                }
                .disabled(!isFormValid)
                
                Spacer()
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Image(systemName: "chevron.left")
                    .foregroundStyle(.white)
                    .imageScale(.large)
                    .onTapGesture {
                        dismiss()
                    }
            }
        }
        
    }
}

#Preview {
    AddEmailView()
}
