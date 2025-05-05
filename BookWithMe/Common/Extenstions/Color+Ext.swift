//
//  Color+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI
extension Color {
    /// 0~255 단위의 RGB 값으로 Color 생성
    static func fromRGB(
        _ red: Double,
        _ green: Double,
        _ blue: Double
    ) -> Color {
        return Color(red: red / 255, green: green / 255, blue: blue / 255)
    }
    
    
    static let baseBackground = Color.fromRGB(204, 224, 255)
    
    static let unableButton = Color.fromRGB(198, 216, 243)
    static let baseButton = Color.fromRGB(135, 196, 255)
    
    static let contentsBackground1 = Color.fromRGB(224, 236, 255)
    static let contentsBackground2 = Color.fromRGB(178, 214, 255)
}
