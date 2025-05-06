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
    func defaultCornerRadius(_ radius: CGFloat = 16) -> some View {
        return self.clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
