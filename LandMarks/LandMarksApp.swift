//
//  LandMarksApp.swift
//  LandMarks
//
//  Created by Timis Petre Leon on 24.09.2024.
//

import SwiftUI

@main
struct LandMarksApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
