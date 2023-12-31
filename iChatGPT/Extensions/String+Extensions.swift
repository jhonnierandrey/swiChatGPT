//
//  String+Extensions.swift
//  iChatGPT
//
//  Created by Jhonnier Zapata on 9/24/23.
//

import Foundation

extension String {
    var isEmptyOrWhiteSpace : Bool {
        self.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}
