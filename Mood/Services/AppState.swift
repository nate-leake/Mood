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

enum AppStateCase: String {
    case ready = "ready"
    case loading = "loading"
    case startup = "startup"
}

class AppState {
    static var shared: AppState = AppState()
    var stateContributors: [Stateable] = []
    
    func addContributor(adding: Stateable){
        stateContributors.append(adding)
    }
    
    @MainActor
    func getAppState() -> AppStateCase {
        var finalState: AppStateCase = .ready
        
        for object in stateContributors {
            switch object.state {
            case .startup:
                print("Contributor is starting: \(object)")
                return .startup
            case .loading:
                finalState = .loading
                print("Contributor is still loading: \(object)")
            case .ready:
                continue
            }
        }
        
        if finalState == .ready {
            print("All contributors are ready.")
        }
        
        return finalState
    }
    
}
