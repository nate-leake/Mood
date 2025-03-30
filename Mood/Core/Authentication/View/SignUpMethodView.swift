//
//  SignUpMethodView.swift
//  Mood
//
//  Created by Nate Leake on 3/20/25.
//

import SwiftUI
import AuthenticationServices

struct SignUpMethodView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @Environment(\.colorScheme) var colorScheme
    @State var currentNonce: String?
    @State var signedUpWithAppleDisplayNext: Bool = false
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack {
                RegistrationHeaderView(header: "no problem", subheading: "how would you like to sign up?")
                
                Spacer()
                
                NavigationLink{
                    AddEmailView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("email & password")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                VStack {
                    Divider()
                        .background(.white)
                    Text("or")
                }
                .foregroundStyle(.white)
                .frame(width: 360)
                .padding(10)
                
                SignInWithAppleButton(.signUp) { request in
                    let nonce = SecurityService.randomNonceString()
                    currentNonce = nonce
                    AuthService.shared.handleSignInWithAppleRequest(request, nonce: nonce)
                } onCompletion: { result in
                    Task {
                        if let result = await AuthService.shared.handleSignInWithAppleCompletion(result, nonce: currentNonce) {
                            viewModel.setAuthResult(to: result)
                        }
                    }
                }
                .signInWithAppleButtonStyle(colorScheme == .light ? .black : .white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .frame(width: 360, height: 44)
                .padding(.bottom, 24)
                .onChange(of: viewModel.signUpWithAppleAuthResult) { old, new in
                    print("RegiVM signUpWithAppleAuthResult old: \(String(describing: old)), new: \(String(describing: new))")
                    if let _ = new {
                        signedUpWithAppleDisplayNext = true
                    } else {
                        print(new ?? "signUpWithAppleAuthResult is nill")
                    }
                }
                
                
                Spacer()
            }
        }
        .navigationDestination(isPresented: $signedUpWithAppleDisplayNext) {
            FinalTouchesView()
                .environmentObject(viewModel)
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
    SignUpMethodView()
        .environmentObject(RegistrationViewModel())
}
