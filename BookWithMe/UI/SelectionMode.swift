//
//  SelectionMode.swift
//  BookWithMe
//
//  Created by 계은성 on 5/12/25.
//

import Foundation

enum SelectionMode {
    case start, end
    
    var dateSelectionLabel: String {
        switch self {
        case .start:
            return "시작일"
        case .end:
            return "종료일"
        }
    }
}
