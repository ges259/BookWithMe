//
//  String.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//

import Foundation

// MARK: - DATE HELPER
extension String {
    var asDate: Date? {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "ko_KR")
        return f.date(from: self)
    }
}




// MARK: - 키워드 문자열 변환(,)
extension String {
//    func toKeywordArray() -> [String] {
//        self.components(separatedBy: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//    }
}
//extension Array where Element == String {
//    func toKeywordString() -> String {
//        self.joined(separator: ",")
//    }
//}




// MARK: - 카테고리 문자열 변환(>)
extension Optional where Wrapped == String {
    /// categoryName 옵셔널 문자열을 [String] 카테고리 배열로 변환
    /// nil → [], "국내도서 > 인문 > 철학" → ["인문", "철학"]
    func toCategoryArray() -> [String] {
        switch self {
        case .some(let raw):
            return raw
                .split(separator: ">")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { $0 != "국내도서" }
        case .none:
            return []
        }
    }
}
extension Array where Element == String {
    /// ["인문", "철학"] → "인문 > 철학"
    func toCategoryString() -> String {
        return self.joined(separator: " > ")
    }
}
