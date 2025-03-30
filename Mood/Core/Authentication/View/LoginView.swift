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
    @StateObject var signUpVM = RegistrationViewModel()
    @StateObject var dataService: DataService = DataService.shared
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    @State var currentNonce: String?
    @State var signedUpWithAppleDisplayNext: Bool = false
    @State var authDataResult: AuthDataResult?
    
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

                VStack {
                    Divider()
                        .background(.white)
                    Text("or")
                }
                .foregroundStyle(.white)
                .frame(width: 360)
                .padding(10)
                
                SignInWithAppleButton() { request in
                    let nonce = SecurityService.randomNonceString()
                    currentNonce = nonce
                    AuthService.shared.handleSignInWithAppleRequest(request, nonce: nonce)
                } onCompletion: { result in
                    Task {
                        authDataResult = await AuthService.shared.handleSignInWithAppleCompletion(result, nonce: currentNonce)
                    }
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 360, height: 44)
                .padding(.bottom, 24)
                .onChange(of: dataService.userSignInNeedsMoreInformation){ old, new in
                    print("LOGIN VIEW: dataservice userNeedsMoreInfo changed from \(old) to \(new)")
                    if new {
                        signUpVM.isSigningUpFromSignIn = true
                        if let res = authDataResult {
                            signUpVM.setAuthResult(to: res)
                        }
                    }
                }
                
                Spacer()
            }
            
        }
        .onChange(of: signUpVM.signUpWithAppleAuthResult) { old, new in
            print("RegiVM signUpWithAppleAuthResult old: \(String(describing: old)), new: \(String(describing: new))")
            if let _ = new {
                signedUpWithAppleDisplayNext = true
            } else {
                print(new ?? "signUpWithAppleAuthResult is nill")
            }
        }
        .navigationDestination(isPresented: $signedUpWithAppleDisplayNext) {
            FinalTouchesView(needsAdditionalInformation: true)
                .environmentObject(signUpVM)
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
