//
//  BookCache+Prefs.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - BookPrefs
extension BookCache {
    func saveBookPrefs() {
        Task {
            do {
                try await CoreDataManager.shared.save(bookPrefs: bookPrefs)
            } catch {
                print("DEBUG: saveBookPrefsError, \(error.localizedDescription)")
            }
        }
    }
    
    func saveBookPrefs(_ bookPrefs: BookPrefs) {
        self.bookPrefs = bookPrefs
    }
}
