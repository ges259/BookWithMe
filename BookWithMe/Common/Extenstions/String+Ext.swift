//
//  String.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//

import Foundation

extension String {
    func toKeywordArray() -> [String] {
        self.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
    }
    // MARK: - DATE HELPER
    var asDate: Date? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "ko_KR")
        return f.date(from: self)
    }
}

extension Array where Element == String {
    func toKeywordString() -> String {
        self.joined(separator: ",")
    }
}


