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
                    .textInputAutocapitalization(.none)
                    .modifier(TextFieldModifier())
                    .padding(.vertical)
                    
                
                NavigationLink{
                    CreatePasswordView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("Next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
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
