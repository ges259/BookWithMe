//
//  StarViewStyle.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import SwiftUI

enum StarViewStyle {
    case custom(height: CGFloat? = 30,
                alignment: Alignment = .leading,
                useGesture: Bool = false
    )
    case auto(alignment: Alignment = .center,
              useGesture: Bool = true
    )
    
    var maxRating: Int {
        return 5
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .custom:
            return 0
        case .auto:
            return 20
        }
    }
    
    var spacing: CGFloat {
        switch self {
        case .custom:
            return 0
        case .auto:
            return 15
        }
    }
    
    var height: CGFloat? {
        switch self {
        case .custom(let height, _, _):
            return height
        case .auto:
            return nil
        }
    }
    
    var alignment: Alignment {
        switch self {
        case .custom(_, let alignment, _),
             .auto(let alignment, _):
            return alignment
        }
    }
    
    var useGesture: Bool {
        switch self {
        case .custom(_, _, let useGesture),
             .auto(_, let useGesture):
            return useGesture
        }
    }
}
