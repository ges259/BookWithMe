//
//  RelaxEngine.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

enum RelaxEngine {
    static func makeRelaxOrder(prefs: [String: [String]], priority: [String]) -> [[String]] {
        let filtered = priority.filter { !(prefs[$0]?.isEmpty ?? true) }
        return (0...filtered.count).map { Array(filtered.prefix($0)) }
    }
}
