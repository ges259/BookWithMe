//
//  StarType.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import SwiftUI

enum StarType {
    case full
    case half
    case empty

    var image: Image {
        switch self {
        case .full:
            return Image.starFill
        case .half:
            return Image.starHalf
        case .empty:
            return Image.starEmpty
        }
    }
}

