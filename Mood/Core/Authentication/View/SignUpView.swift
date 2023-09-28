//
//  SignUpView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
        
                        
            VStack{
                Text("no problem")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("we'll need these few things from you")
                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 45){
                    Text("\u{2022} email")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\u{2022} password")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\u{2022} name")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\u{2022} birthday")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                NavigationLink{
                    AddEmailView()
                        .navigationBarBackButtonHidden()
                } label: {
                    Text("next")
                        .font(.headline)
                        .fontWeight(.bold)
                        .frame(width: 360, height: 44)
                        .foregroundStyle(.appPurple)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
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
    SignUpView()
}
