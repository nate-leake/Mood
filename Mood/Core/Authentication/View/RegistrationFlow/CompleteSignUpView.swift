//
//  CompleteSignUpView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct CompleteSignUpView: View, Hashable {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State var isLoading: Bool = false
    @State var errorMessage: String = ""
    
    static func == (lhs: CompleteSignUpView, rhs: CompleteSignUpView) -> Bool {
        return true // Since there are no distinguishing properties
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(0) // Simple hash since there are no stored properties
    }
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            VStack{
                RegistrationHeaderView(header: "all set", subheading: viewModel.isSigningUpFromSignIn ? "click below to continue" : "click below to finish signing up")
                
                Spacer()
                
                if errorMessage.count > 0 {
                    Text(errorMessage)
                        .foregroundStyle(.white)
                        .font(.headline)
                        .padding(7)
                        .background(.appRed)
                        .clipShape(RoundedRectangle(cornerRadius: 15))
                        .padding()
                }
                
                VStack(spacing: 45) {
                    Text("here's what we have")
                        .font(.title2)
                        .foregroundStyle(.appPurple)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    VStack(alignment: .leading, spacing: 45){
                        Text("username: \(viewModel.name)")
                            .font(.title2)
                            .foregroundStyle(.appPurple)
                        Text("email: \(viewModel.email)")
                            .font(.title2)
                            .foregroundStyle(.appPurple)
                        Text("birthday: \(dateFormatter.string(from: viewModel.birthday))")
                            .font(.title2)
                            .foregroundStyle(.appPurple)
                    }
                }
                .padding()
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                
                Spacer()
                
                ZStack {
                    Button{
                        withAnimation(.easeInOut) {
                            isLoading = true
                        }
                        Task {
                            do {
                                print("RegiVm from CompoleteSignUpView. Current authResult: \(String(describing: viewModel.signUpWithAppleAuthResult))")
                                let msg: String = try await viewModel.createUser()
                                withAnimation(.easeInOut){
                                    errorMessage = msg
                                    isLoading = false
                                }
                            } catch {
                                withAnimation(.easeInOut){
                                    isLoading = false
                                }
                            }
                        }
                    } label: {
                        var buttonText: String {
                            if viewModel.isSigningUpFromSignIn {
                                return "continue signn in"
                            } else {
                                return "complete sign up"
                            }
                        }
                        Text(isLoading ? "creating account..." : buttonText)
                            .font(.headline)
                            .fontWeight(.bold)
                            .frame(width: 360, height: 44)
                            .foregroundStyle(.appPurple)
                            .background(isLoading ? .white.opacity(0.5) : .white)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .disabled(isLoading)
                    .loadable(isLoading: $isLoading, shape: RoundedRectangle(cornerRadius: 8), frameSize: CGSize(width: 360, height: 44))
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
