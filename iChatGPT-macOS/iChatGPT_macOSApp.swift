//
//  iChatGPT_macOSApp.swift
//  iChatGPT-macOS
//
//  Created by Jhonnier Zapata on 9/20/23.
//

import SwiftUI

@main
struct iChatGPT_macOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
