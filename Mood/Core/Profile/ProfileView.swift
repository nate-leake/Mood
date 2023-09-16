//
//  ProfileView.swift
//  Mood
//
//  Created by Nate Leake on 9/12/23.
//

import SwiftUI

struct ProfileView: View {
    
    func logout(){
        print("log out user")
    }
    
    var body: some View {
        NavigationStack {
            Text("This is your profile")
            
            Button {
                logout()
            } label: {
                Text("log out")
            }
            
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    ProfileView()
}
