//
//  Array+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 6/2/25.
//

import Foundation

// MARK: - Enum Array <-> String 변환기
extension Array where Element: RawRepresentable, Element.RawValue == String {
    
    /// 배열 → "값1,값2,값3"
    /// 배열의 각 `enum`의 `rawValue`를 쉼표로 구분된 문자열로 변환
    /// 예시: [LanguageOption.english, LanguageOption.korean] → "English,Korean"
    var toCommaSeparated: String {
        map(\.rawValue)               // 각 enum의 rawValue를 추출
            .joined(separator: ",")    // 쉼표로 구분된 문자열로 결합
    }
    
    /// "값1,값2,값3" → [Element]
    /// 쉼표로 구분된 문자열을 받아서 해당 `enum` 배열로 변환
    /// 예시: "English,Korean" → [LanguageOption.english, LanguageOption.korean]
    static func fromCommaSeparated(_ string: String) -> [Element] {
        string
            .split(separator: ",")            // 쉼표로 문자열을 분리
            .compactMap { Element(rawValue: String($0)) } // 각 문자열을 `enum`으로 변환
    }
}
