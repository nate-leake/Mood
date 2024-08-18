//
//  ProfileView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI



struct ProfileView: View {
    @EnvironmentObject var dailyDataService: DailyDataService
    @State private var numberOfEntries: Int? = nil
    var user : User
    
    func fetchResult() async {
        do {
            let value = try await dailyDataService.getNumberOfEntries()
            numberOfEntries = value
        } catch {
            print(error.localizedDescription)
            numberOfEntries = 0
        }
    }
    
    private let dateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }()
    
    var body: some View {
        NavigationStack {
            VStack{
                VStack{
                    Text("\(numberOfEntries ?? 0)")
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
                .onAppear {
                    Task {
                        await fetchResult()
                    }
                }
                
                List{
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
            
            
            .navigationTitle("profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ProfileView(user: User.MOCK_USERS[0])
}
