//
//  LoginView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI
import AuthenticationServices
import FirebaseAuth

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    @StateObject var viewModel = LoginViewModel()
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    @State var currentNonce: String?
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack{
                Spacer()
                Text("we're glad you're back")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                if errorMessage.count > 0 {
                    Text(errorMessage)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(7)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }
                
                TextField("", text: $viewModel.email, prompt: Text("email").foregroundStyle(.gray))
                    .textInputAutocapitalization(.never)
                    .modifier(TextFieldModifier())
                    .keyboardType(.emailAddress)
                
                SecureInputView("", text: $viewModel.passwd, prompt: Text("password").foregroundStyle(.gray))
                    .modifier(TextFieldModifier())
                
                Button{
                    withAnimation(.easeInOut) {
                        isLoading = true
                    }
                    Task {
                        let msg: String = try await viewModel.signin()
                        withAnimation(.easeInOut){
                            errorMessage = msg
                            isLoading = false
                        }
                    }
                } label: {
                    Text(isLoading ? "logging in..." : "log in")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(isLoading ? .white.opacity(0.5) : .white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .disabled(isLoading || viewModel.email.isEmpty || viewModel.passwd.isEmpty)
                .opacity(viewModel.email.isEmpty || viewModel.passwd.isEmpty ? 0.5 : 1)
                .loadable(isLoading: $isLoading, shape: RoundedRectangle(cornerRadius: 8), frameSize: CGSize(width: 360, height: 44))

                
                Spacer()
                
                SignInWithAppleButton() { request in
                    let nonce = SecurityService.randomNonceString()
                    currentNonce = nonce
                    viewModel.handleSignInWithAppleRequest(request, nonce: nonce)
                } onCompletion: { result in
                    viewModel.handleSignInWithAppleCompletion(result, nonce: currentNonce)
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 360, height: 44)
                .padding(.bottom, 24)
                
                Spacer()
            }
            
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading){
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.white)
                        .imageScale(.large)
                }
            }
        }
        
    }
}

#Preview {
    LoginView()
}
