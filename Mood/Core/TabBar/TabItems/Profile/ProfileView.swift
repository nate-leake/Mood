//
//  ProfileView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct ProfileViewTile: View {
    var title: String
    var subtitle: String
    var backgroundColor: Color
    
    var body: some View {
        VStack(){
            Text(title)
                .font(.title)
                .bold()
                .padding()
                .foregroundStyle(backgroundColor.optimalForegroundColor())
                .frame(minWidth: 70)
                .background(backgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 8.0))
            
            Text(subtitle)
                .font(.caption)
                .frame(width: 70)
                .multilineTextAlignment(.center)
                .lineLimit(2)
            
            Spacer()
        }
        
    }
}

extension ProfileView {
    
    func topTileView() -> some View {
        HStack(spacing: 20) {
            Spacer()
            
            ProfileViewTile(title: "\(dataService.numberOfEntries)", subtitle: "entries", backgroundColor: .appGreen)
            
            ProfileViewTile(title: "\(dataService.numberOfCompletedObjectives)", subtitle: "completed objectives", backgroundColor: .appBlue)
            
            Spacer()
        }
        .frame(maxHeight: 130)
    }
}

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
                    
                    topTileView()
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
        .environmentObject(DataService.shared)
        .onAppear{
            DataService.shared.numberOfEntries = 1500
            DataService.shared.numberOfCompletedObjectives = 10
        }
}
