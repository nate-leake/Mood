//
//  LoginView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack{
                Text("we're gald you're back")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                
                TextField("", text: $viewModel.email, prompt: Text("email").foregroundStyle(.gray))
                    .textInputAutocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                SecureField("", text: $viewModel.passwd, prompt: Text("password").foregroundStyle(.gray))
                    .textInputAutocapitalization(.none)
                    .modifier(TextFieldModifier())
                
                Button{
                    Task { try await viewModel.signin()}
                } label: {
                    Text("log in")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundStyle(.appPurple)
                        .frame(width: 360, height: 44)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .padding(.vertical)
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
    LoginView()
}
