//
//  ContentView.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/24/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isPresented: Bool = false
    
    var body: some View {
        NavigationStack {
            MainView()
                .navigationTitle("iChatGPT")
                .sheet(isPresented: $isPresented, content: {
                    NavigationStack {
                        HistoryView()
                            .navigationTitle("History")
                    }
                })
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            isPresented = true
                        } label: {
                            Text("History")
                        }
                    }
                }
                
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(Model())
        .environment(\.managedObjectContext, CoreDataManager.shared.persistentContainer.viewContext)
}
