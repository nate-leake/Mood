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
            Text("This is your profile")
            
            Button {
                AuthService.shared.signout()
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
