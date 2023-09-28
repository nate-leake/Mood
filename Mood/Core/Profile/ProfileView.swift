//
//  ProfileView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    Text("37")
                        .font(.title)
                    Text("entries")
                }
                .foregroundStyle(.white)
                .background(
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(.appGreen)
                        .frame(width: 80, height: 80)
                )
                .padding(.top, 20)
                .padding(.bottom, 10)
                
                List{
                    Section{
                        HStack{
                            Text("name")
                            Spacer()
                            Text("Bob")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        HStack{
                            Text("email")
                            Spacer()
                            Text(verbatim: "bob@gmail.com")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        HStack{
                            Text("birthday")
                            Spacer()
                            Text("August 12, 3019")
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                    .modifier(ListRowBackgroundModifer())
                    
                    Button {
                        AuthService.shared.signout()
                    } label: {
                        HStack{
                            Spacer()
                            Text("log out")
                                .foregroundStyle(.appRed)
                            Spacer()
                        }
                    }
                    .modifier(ListRowBackgroundModifer())
                }
                .scrollContentBackground(.hidden)
            }
            
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ProfileView()
}
