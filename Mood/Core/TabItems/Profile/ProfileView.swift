//
//  ProfileView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI



struct ProfileView: View {
    @EnvironmentObject var dataService: DataService
    var user : User
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack{
                
                List{
                    HStack {
                        Spacer()
                        VStack(){
                            Text("\(dataService.numberOfEntries)")
                                .font(.title)
                            Text("entries")
                        }
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 8.0)
                                .fill(.appGreen)
                                .frame(width: 80, height: 80)
                        )
                        .padding(.top, 3)
                        .padding(.bottom, 3)
                        Spacer()
                    }
                    .modifier(ListRowBackgroundModifer(foregroundColor: .clear))
                    
                    Section{
                        HStack{
                            Text("name")
                            Spacer()
                            Text("\(user.name)")
                                .font(.callout)
                                .foregroundStyle(.gray)
                        }
                        HStack{
                            Text("email")
                            Spacer()
                            Text(verbatim: "\(user.email)")
                                .font(.callout)
                                .foregroundStyle(.gray)
                        }
                        HStack{
                            Text("birthday")
                            Spacer()
                            Text("\(dateFormatter.string(from: user.birthday))")
                                .font(.callout)
                                .foregroundStyle(.gray)
                        }
                        
                    }
                    .modifier(ListRowBackgroundModifer())
                    
                    Section {
                        NavigationLink{
                            SettingsAndPrivacyView()
                        } label: {
                            Text("settings and privacy")
                        }
                    }
                    .modifier(ListRowBackgroundModifer())
                    
                    Section{
                        NavigationLink {
                            ContextSelectorView()
                        } label: {
                            Text("edit contexts")
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
        }
        
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[0])
        .environmentObject(DataService())
}
