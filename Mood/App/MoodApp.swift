//
//  MoodApp.swift
//  Mood
//
//  Created by Nate Leake on 9/11/23.
//

import SwiftUI
import Firebase

@main
struct MoodApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
