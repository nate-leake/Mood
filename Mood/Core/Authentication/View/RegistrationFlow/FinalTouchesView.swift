//
//  SignUpView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

struct FinalTouchesView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    @State var needsAdditionalInformation: Bool = false
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
            
            VStack{
                if needsAdditionalInformation {
                    RegistrationHeaderView(header: "additional information", subheading: "we need more information to continue")
                } else {
                    RegistrationHeaderView(header: "final touches", subheading: "we'll need these few things from you")
                }
                
                Spacer()
                
                VStack(spacing: 45){
                    
                    Text("\u{2022} username")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\u{2022} birthday")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                    
                    Text("\u{2022} pin")
                        .font(.title2)
                        .foregroundStyle(.white)
                        .fontWeight(.bold)
                }
                .onAppear{
                    print("RegiVM from FinalTouchesView. Current AuthResult: \(String(describing: viewModel.signUpWithAppleAuthResult))")
                }
                
                Spacer()
                
                NavigationLink{
                    AddNameView()
                        .navigationBarBackButtonHidden()
                        .environmentObject(viewModel)
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
    FinalTouchesView()
        .environmentObject(RegistrationViewModel())
}
