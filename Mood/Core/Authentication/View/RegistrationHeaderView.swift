//
//  RegistrationHeaderView.swift
//  Mood
//
//  Created by Nate Leake on 10/17/24.
//

import SwiftUI

struct RegistrationHeaderView: View {
    var header: String
    var subheading: String
    
    var body: some View {
        Text(header)
            .font(.title)
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .multilineTextAlignment(.center)
            .padding(.bottom, 7)
        
        Text(subheading)
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(.bottom, 10)
        
        Rectangle()
            .frame(width: 300, height: 0.5)
            .foregroundStyle(.white)
    }
}

#Preview {
    RegistrationHeaderView(header: "setup", subheading: "set up your things!")
}
