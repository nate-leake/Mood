//
//  LoginView.swift
//  Mood
//
//  Created by Nate Leake on 9/14/23.
//

import SwiftUI

struct WelcomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack{
                Color.appPurple
                    .ignoresSafeArea()
                
                VStack(spacing: 30) {
                    
                    VStack (spacing:20){
                        HStack(spacing: 30){
                            Image(systemName: "sun.max")
                                .foregroundStyle(.appYellow)
                            Image(systemName: "briefcase.fill")
                                .foregroundStyle(Color(hex: "#53555f"))
                            Image(systemName: "figure.and.child.holdinghands")
                                .foregroundStyle(Color(hex: "#009c13"))
                            Image(systemName: "stethoscope")
                                .foregroundStyle(.appRed)
                        }
                        .font(.title)
                        .fontWeight(.bold)
                        
                        Text("welcome to mood.")
                            .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                            .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                            .foregroundStyle(.white)
                        
                        Rectangle()
                            .frame(width: 300, height: 0.5)
                            .foregroundStyle(.white)
                    }
                    
                    
                    VStack{
                        Text("do you have an account?")
                            .fontWeight(.bold)
                            .foregroundStyle(.white)
                        
                        HStack(spacing:20){
                            NavigationLink{
                                LoginView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Text("yes")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: 100, height: 44)
                                    .foregroundStyle(.appPurple)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                            
                            NavigationLink{
                                SignUpView()
                                    .navigationBarBackButtonHidden()
                            } label: {
                                Text("no")
                                    .font(.headline)
                                    .fontWeight(.bold)
                                    .frame(width: 100, height: 44)
                                    .foregroundStyle(.appPurple)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                                        
                }
            }
        }
    }
}

#Preview {
    WelcomeView()
}
