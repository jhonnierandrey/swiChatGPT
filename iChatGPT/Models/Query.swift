//
//  Query.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/24/23.
//

import Foundation

struct Query: Identifiable, Hashable {
    let id = UUID()
    let question: String
    let answer: String
}
