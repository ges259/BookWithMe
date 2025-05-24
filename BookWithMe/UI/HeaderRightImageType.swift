//
//  HeaderRightImageType.swift
//  BookWithMe
//
//  Created by 계은성 on 5/15/25.
//

import SwiftUI

enum HeaderRightImageType {
    case none
    case rightChevron
//    case trash
    
    var image: Image? {
        switch self {
        case .none:             return nil
        case .rightChevron:     return Image.chevronRight
//        case .trash:            return Image.trash
        }
    }
}
