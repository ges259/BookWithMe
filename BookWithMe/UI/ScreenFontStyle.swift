//
//  ScreenFontStyle.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI

enum AppFontStyle {
    case bookShelfHeader
    case bookShelfCell
    case bookDataTitle
    case bookDataContent
    case readingHistorySectionTitle
    
    case historyHeaderViewFont

    var font: Font {
        switch self {
        case .bookShelfHeader: 
            return .system(size: 22, weight: .bold)
        case .bookShelfCell: 
            return .system(size: 16)
        case .bookDataTitle: 
            return .system(size: 20, weight: .semibold)
        case .bookDataContent:
            return .system(size: 14)
        case .readingHistorySectionTitle: 
            return .system(size: 18, weight: .medium)
        case .historyHeaderViewFont:
            return .system(size: 17)
        }
    }
}
