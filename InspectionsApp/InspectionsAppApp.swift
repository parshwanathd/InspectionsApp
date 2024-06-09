//
//  InspectionsAppApp.swift
//  InspectionsApp
//
//  Created by Parshwanath on 6/8/24.
//

import SwiftUI

@main
struct InspectionsAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            LoginView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

struct MyContentView: View {
    @State private var isShowingDetailView = false

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink(destination: Text("Second View"), isActive: $isShowingDetailView) { EmptyView() }
                Button("Tap to show detail") {
                    self.isShowingDetailView = true
                }
            }
            .navigationTitle("Navigation")
        }
    }
}
