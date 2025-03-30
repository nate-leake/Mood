//
//  AddNameView.swift
//  Mood
//
//  Created by Nate Leake on 9/28/23.
//

import SwiftUI

struct AddNameView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    private let nameMaxLenght: Int = 12
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
                        
            VStack{
                RegistrationHeaderView(header: "add a username",
                                       subheading: "this is what we'll call you\n(it doesn't have to be your real name)"
                )
                
                TextField("", text: $viewModel.name, prompt: Text("username").foregroundStyle(.gray))
                    .textInputAutocapitalization(.never)
                    .disableAutocorrection(true)
                    .modifier(TextFieldModifier())
                    .padding(.vertical)
                    .onChange(of: viewModel.name) {
                        viewModel.name = String(viewModel.name.prefix(nameMaxLenght))
                    }
                    
                
                NavigationLink{
                    AddBirthdayView()
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
    AddNameView()
        .environmentObject(RegistrationViewModel())
}
