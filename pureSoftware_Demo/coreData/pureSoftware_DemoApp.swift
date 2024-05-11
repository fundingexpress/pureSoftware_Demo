//
//  pureSoftware_DemoApp.swift
//  pureSoftware_Demo
//
//  Created by admin on 11/05/24.
//

import SwiftUI

@main
struct pureSoftware_DemoApp: App {
    let persistenceController = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
