//
//  HistoryView.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/21/23.
//

import SwiftUI

struct HistoryView: View {
    
    @EnvironmentObject private var model : Model
    @Environment(\.dismiss) private var dismiss
    
    @FetchRequest(sortDescriptors: [NSSortDescriptor(key: "dateCreated", ascending: true)]) private var historyItemResult : FetchedResults<HistoryItem>
    
    var body: some View {
        List(historyItemResult){ historyItem in
            Text(historyItem.question ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
                .onTapGesture {
                    model.query = Query(question: historyItem.question ?? "", answer: historyItem.answer ?? "")
                    #if os(iOS)
                            dismiss()
                    #endif
                }
        }
    }
}

#Preview {
    HistoryView()
        .environmentObject(Model())
}
