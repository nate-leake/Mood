//
//  CreatePasswordView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct CreatePasswordView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    @State private var isFormValid: Bool = false
    
    func isValidPassword() -> Bool {
        
//        ^                         Start anchor
//        (?=.*[A-Z])        Ensure string has one uppercase letters.
//        (?=.*[!@#$&*])            Ensure string has one special case letter.
//        (?=.*[0-9])        Ensure string has one digits.
//        (?=.*[a-z].*[a-z].*[a-z]) Ensure string has three lowercase letters.
//        .{8}                      Ensure string is of length 8.
//        $                         End anchor.
        
        let psswdRegEx = "^(?=.*[A-Z])(?=.*[!@#$&*])(?=.*[0-9])(?=.*[a-z].*[a-z].*[a-z]).{8,}$"

        let psswdPred = NSPredicate(format:"SELF MATCHES %@", psswdRegEx)
        return psswdPred.evaluate(with: viewModel.passwd)
    }
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack{
                Text("create a password")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("it should have")
                    .foregroundStyle(.white)
                
                HStack{
                    Spacer()
                    Text("\u{2022} at least 8 characters")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\u{2022} one number")
                        .foregroundStyle(.white)
                    Spacer()
                }
                HStack{
                    Spacer()
                    Text("\u{2022} one special character")
                        .foregroundStyle(.white)
                    Spacer()
                    Text("\u{2022} one upper case letter")
                        .foregroundStyle(.white)
                    Spacer()
                }
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                
                SecureInputView("", text: $viewModel.passwd, 
                                prompt: Text("password").foregroundStyle(.gray))
                    .modifier(TextFieldModifier())
                    .padding(.vertical)
                    .onChange(of: viewModel.passwd) {
                        self.isFormValid = isValidPassword()
                    }
                
                NavigationLink{
                    AddNameView()
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
                }.disabled(!isFormValid)
                
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
    CreatePasswordView()
        .environmentObject(RegistrationViewModel())
}
