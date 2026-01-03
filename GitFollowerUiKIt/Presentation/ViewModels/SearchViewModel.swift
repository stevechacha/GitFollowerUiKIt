//
//  SearchViewModel.swift
//  GitFollowerUiKIt
//
//  Created by stephen chacha on 24/08/2024.
//

import Foundation

final class SearchViewModel {
    var username: String = ""
    
    func validateUsername(_ text: String?) -> Bool {
        guard let text = text else { return false }
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        username = trimmed
        return !trimmed.isEmpty
    }
    
    func getValidatedUsername() -> String? {
        guard !username.isEmpty else { return nil }
        return username
    }
}

