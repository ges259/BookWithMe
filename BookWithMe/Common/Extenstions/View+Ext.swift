//
//  View+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

extension View {
    func defaultShadow() -> some View {
        self.shadow(
            color: .black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
    }

    
    @ViewBuilder
    func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }
    
    func bookSize(_ type: BookCardSize) -> some View {
        let size = type.bookSize
        return self.frame(width: size.width, height: size.height)
    }
    
    func roundedTopCorners(
        _ radius: CGFloat = 35
    ) -> some View {
        return self.clipShape(UnevenRoundedRectangle(
            topLeadingRadius: radius,
            topTrailingRadius: radius
        ))
    }
    
    func roundedTopTrailingCorners(
        _ radius: CGFloat = 20
    ) -> some View {
        return self.clipShape(UnevenRoundedRectangle(
            topTrailingRadius: radius
        ))
    }
    func defaultCornerRadius(_ radius: CGFloat = 16) -> some View {
        return self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
    
    
    
    
    func bottomSheetGesture(onDismiss: @escaping () -> Void) -> some View {
        self.gesture(
            DragGesture()
                .onEnded { value in
                    withAnimation(.easeInOut) {
                        if value.translation.height > 150
                                || value.predictedEndLocation.y > 400
                        { 
                            onDismiss()
                        }
                    }
                }
        )
    }
    
    
    
    func appFont(_ style: AppFontStyle) -> some View {
        self.font(style.font)
    }
}
