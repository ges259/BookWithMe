//
//  Dictionary+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

extension Dictionary where Key == String, Value == [String] {
    func jsonString() -> String {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: .prettyPrinted),
              let string = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return string
    }
}
