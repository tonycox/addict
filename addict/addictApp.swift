//
//  addictApp.swift
//  addict
//
//  Created by Anton Solovev on 28/08/2023.
//

import SwiftUI

@main
struct addictApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
