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
    
    
    var dateClosedRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -125, to: Date())!
        let max = Calendar.current.date(byAdding: .year, value: -13, to: Date())!
        return min...max
    }
    
    var body: some View {
        ZStack{
            Color.appPurple
                .ignoresSafeArea()
                        
            VStack{
                RegistrationHeaderView(header: "add your birthday", subheading: "you'll need to be at least 13")
     
                DatePicker(selection: $viewModel.birthday, in: dateClosedRange, displayedComponents: .date){}
                    .datePickerStyle(.wheel)
                    .tint(.accent)
                    .frame(width: 200, alignment: .center)
                
                NavigationLink{
                    AddPinView()
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
    AddBirthdayView()
        .environmentObject(RegistrationViewModel())
}
