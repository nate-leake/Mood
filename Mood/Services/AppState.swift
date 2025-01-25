//
//  AppState.swift
//  Mood
//
//  Created by Nate Leake on 10/1/24.
//

import Foundation

protocol Stateable {
    var state: AppStateCase { get }
}

enum PrintableStates: String {
    case none = ""
    case ok = "🟢"
    case warning = "⚠️"
    case error = "❌"
    case fatal = "‼️💀‼️"
    case cold = "🔵"
    case debug = "🪲"
}

enum AppStateCase: String {
    case ready = "ready"
    case loading = "loading"
    case startup = "startup"
}

class AppState {
    static var shared: AppState = AppState()
    var stateContributors: [Stateable] = []
    
    private func cp(_ text: String, state: PrintableStates = .none) {
        let finalString = "🔄\(state.rawValue) APP STATE: " + text
        print(finalString)
    }
    
    func addContributor(adding: Stateable){
        stateContributors.append(adding)
    }
    
    @MainActor
    func getAppState() -> AppStateCase {
        var finalState: AppStateCase = .ready
        
        for object in stateContributors {
            switch object.state {
            case .startup:
                cp("Contributor is starting: \(object)", state: .cold)
                return .startup
            case .loading:
                finalState = .loading
                cp("Contributor is still loading: \(object)", state: .cold)
            case .ready:
                continue
            }
        }
        
        if finalState == .ready {
            cp("All contributors are ready.", state: .ok)
        }
        
        return finalState
    }
    
}
