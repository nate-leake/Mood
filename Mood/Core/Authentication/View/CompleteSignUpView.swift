//
//  CompleteSignUpView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct CompleteSignUpView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .none
        formatter.dateStyle = .full
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack{
                
                Text("all set")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                Text("click below to finish signing up")
                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                
                Spacer()
                
                VStack(spacing: 45){
                    Text("here's what we have")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    Text("name: \(viewModel.name)")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    Text("email: \(viewModel.email)")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    Text("birthday: \(dateFormatter.string(from: viewModel.birthday))")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                
                Spacer()
//                
                Button{
                    Task { try await viewModel.createUser() }
                } label: {
                    Text("complete sign up")
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
    CompleteSignUpView()
        .environmentObject(RegistrationViewModel())
}
