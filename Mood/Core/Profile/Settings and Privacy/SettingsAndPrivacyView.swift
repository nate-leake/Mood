//
//  SettingsAndPrivacyView.swift
//  Mood
//
//  Created by Nate Leake on 10/9/24.
//

import SwiftUI

struct SettingsAndPrivacyView: View {
    
    @AppStorage("lockAppOnBackground") var lockAppOnBackground: Bool = true
    @AppStorage("useBiometricsToUnlock") var useBiometricsToUnlock: Bool = false
    
    
    var body: some View {
        
        VStack{
            List {
                Section {
                    Toggle("always require pin", isOn: $lockAppOnBackground)
                    Toggle("use biometrics to unlock", isOn: $useBiometricsToUnlock)
                        .onChange(of: useBiometricsToUnlock) { old, new in
                            if old == false && new == true {
                                AuthService.shared.unlockUsingBiometrics() { result in
                                    switch result {
                                    case .success(_):
                                        useBiometricsToUnlock = true
                                    case .failure(_):
                                        useBiometricsToUnlock = false
                                    }
                                }
                                
                            }
                        }
                    
                }
                .tint(.appPurple)
                .modifier(ListRowBackgroundModifer())
            }
            
            
        }
        .navigationTitle("settings and privacy")
        .navigationBarTitleDisplayMode(.inline)
        
    }
}

#Preview {
    SettingsAndPrivacyView()
}
