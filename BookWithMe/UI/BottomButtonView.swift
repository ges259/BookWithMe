//
//  BottomButtonView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/14/25.
//

import SwiftUI

struct BottomButtonView: View {
    var title: String
    var action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 50)
                .foregroundStyle(Color.black)
                .contentShape(Rectangle()) // 터치 영역 확장
        }
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
}
//.padding(.horizontal, 10)
