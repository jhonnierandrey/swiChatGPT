//
//  ContentView.swift
//  iChatGPT-macOS
//
//  Created by Jhonnier Zapata on 9/20/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            HistoryView()
        } detail: {
            MainView()
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Model())
        .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
}
