//
//  AddBirthdayView.swift
//  Mood
//
//  Created by Nate Leake on 9/15/23.
//

import SwiftUI

var globalDate = Date.now

struct AddBirthdayView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: RegistrationViewModel
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
            
                        
            VStack{
                Text("add your birthday")
                    .font(.title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
//                Text("you'll use this to sign in")
//                    .foregroundStyle(.white)
                
                Rectangle()
                    .frame(width: 300, height: 0.5)
                    .foregroundStyle(.white)
                

                
                DatePicker(selection: $viewModel.birthday, in: ...Date.now, displayedComponents: .date){}
                    .datePickerStyle(.wheel)
                    .tint(.accent)
                    .frame(width: 200, alignment: .center)
                
                NavigationLink{
                    CompleteSignUpView()
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
    AddBirthdayView()
}
