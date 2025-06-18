//
//  BookCardSize.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import SwiftUI

enum BookCardSize {
    case large, medium, small, flexible
//    case

    var baseWidthRatio: CGFloat? {
        switch self {
        case .large: return 0.6
        case .medium: return 0.3
        case .small: return 0.2
        case .flexible: return nil
        }
    }

    var aspectRatio: CGFloat {
        // width : height = 2 : 3 → height = width * 1.5 → 3/2
        return 3.0 / 2.0
    }

    var bookSize: CGSize? {
        guard let ratio = baseWidthRatio else { return nil }
        let baseWidth = UIScreen.main.bounds.width * ratio
        return CGSize(width: baseWidth, height: baseWidth * aspectRatio)
    }
    
    
    
    var titleSize: CGFloat {
        switch self {
        case .small:
            return 15
        case .medium, .large, .flexible:
            return 20
        }
    }
}
