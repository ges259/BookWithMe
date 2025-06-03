//
//  View+Ext.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

extension View {
    // MARK: - shadow
    func defaultShadow() -> some View {
        self.shadow(
            color: .black.opacity(0.1),
            radius: 4,
            x: 0,
            y: 2
        )
    }

    // MARK: - ViewBuilder-if
    @ViewBuilder
    func `if`<Content: View>(
        _ condition: Bool,
        transform: (Self) -> Content
    ) -> some View {
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
    
    
    // MARK: - CornerRadius
    func defaultCornerRadius(
        corners: Corner = .none,
        _ radius: CGFloat = 16
    ) -> some View {
         let resolved = corners.resolvedCorners
        
         let shape = UnevenRoundedRectangle(
             topLeadingRadius: resolved.contains(.topLeading) ? radius : 0,
             bottomLeadingRadius: resolved.contains(.bottomLeading) ? radius : 0,
             bottomTrailingRadius: resolved.contains(.bottomTrailing) ? radius : 0,
             topTrailingRadius: resolved.contains(.topTrailing) ? radius : 0
         )
         return self.clipShape(shape)
     }
    
    // MARK: - BottomSheet
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

enum Corner {
    case none
    
    case topLeading
    case topTrailing
    case bottomLeading
    case bottomTrailing
    
    case top
    case bottom
    case leading
    case trailing
    
    var resolvedCorners: [Corner] {
        switch self {
        case .none:
            return [.topLeading, .topTrailing, .bottomLeading, .bottomTrailing]
        case .top: 
            return [.topLeading, .topTrailing]
        case .bottom:
            return [.bottomLeading, .bottomTrailing]
        case .leading:
            return [.topLeading, .bottomLeading]
        case .trailing:
            return [.topTrailing, .bottomTrailing]
        default:
            return [self]
        }
    }
}



// MARK: - confirmationAlert
extension View {
    func confirmationAlert(
        isPresented: Binding<Bool>,
        type: ConfirmationType
    ) -> some View {
        self.confirmationDialog(
            type.title,
            isPresented: isPresented,
            titleVisibility: .visible
        ) {
            Button(type.confirmTitle, role: .destructive, action: type.action)
            Button("취소", role: .cancel) {}
        } message: {
            if let message = type.message {
                Text(message)
            }
        }
    }
}


extension Date {
    /// Date를 "yyyy.MM.dd" 형식으로 변환합니다.
    static func formatDate(_ date: Date?) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: date ?? Date())
    }
}
