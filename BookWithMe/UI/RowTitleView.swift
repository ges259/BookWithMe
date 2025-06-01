//
//  RowTitleView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import SwiftUI

// MARK: - RowTitleView
/// UI - 테이블의 행의 데이터(UI 및 타이틀)를 설정하는 함수
struct RowTitleView: View {
    let title: String
    let isFirstCell: Bool

    var body: some View {
        Text(title)
            .frame(width: 60, height: 50, alignment: .leading)
            .padding(.horizontal, 20)
            .background(Color.contentsBackground2)
            .font(.subheadline)
            .foregroundColor(.black)
            .if(isFirstCell) {
                $0.defaultCornerRadius(corners: .topTrailing)
            }
    }
}
// MARK: - RowDetailTextView
struct RowDetailTextView: View {
    var detatilText: String?
    
    var body: some View {
        return Text(detatilText ?? "")
            .font(.body)
            .multilineTextAlignment(.leading)
            .frame(maxWidth: .infinity, alignment: .leading)
            .frame(height: 50)
    }
}
