//
//  NotableMomentsView.swift
//  Mood
//
//  Created by Nate Leake on 4/26/25.
//

import SwiftUI

struct NotableMomentsView: View {
    @Namespace var momentsNamespace
    @ObservedObject var dataService: DataService = DataService.shared
    
    var body: some View {
        VStack {
            ScrollView {
                ForEach(dataService.loadedMoments) { moment in
                    NavigationLink {
                        EditNotableMomentView(editing: moment)
                            .navigationTransition(.zoom(sourceID: moment.id, in: momentsNamespace))
                    } label: {
                        NotableMomentTileView(title: moment.title, description: moment.description, date: moment.date, color: Color(moment.pleasureSelection.rawValue.capitalized))
                            .padding(.bottom, 10)
                    }
                    .matchedTransitionSource(id: moment.id, in: momentsNamespace)
                }
                TabBarSpaceReservation()
            }
        }
        .navigationTitle("notable moments")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing){
                NavigationLink {
                    AddNotableMomentView()
                } label: {
                    Image(systemName: "note.text.badge.plus")
                        .imageScale(.large)
                        .foregroundStyle(.appGreen)
                }
            }
        }
    }
}

#Preview {
    @Previewable @StateObject var dataService = DataService.shared
    NotableMomentsView()
        .environmentObject(dataService)
        .onAppear {
            dataService.loadedMoments = UnsecureNotableMoment.MOCK_DATA
        }
}
