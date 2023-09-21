//
//  iChatGPT_iOSApp.swift
//  iChatGPT-iOS
//
//  Created by Jhonnier Zapata on 9/20/23.
//

import SwiftUI

@main
struct iChatGPT_iOSApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(Model())
                .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
        }
    }
}
