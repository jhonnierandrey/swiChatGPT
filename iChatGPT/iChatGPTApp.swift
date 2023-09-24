//
//  iChatGPTApp.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/24/23.
//

import SwiftUI

@main
struct iChatGPTApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Model())
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
