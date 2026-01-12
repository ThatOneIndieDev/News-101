//
//  AlJazeeraRemakeApp.swift
//  AlJazeeraRemake
//
//  Created by Syed Abrar Shah on 12/01/2026.
//

import SwiftUI
import CoreData

@main
struct AlJazeeraRemakeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
