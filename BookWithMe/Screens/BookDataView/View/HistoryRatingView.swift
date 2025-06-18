//
//  HistoryRatingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI
import BottomSheet

// MARK: - HistoryRatingView
struct HistoryRatingView: View {
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var rating: Double

    var body: some View {
        VStack(spacing: 10) {
            headerView
            ratingView
            bottomButtonView
        }
        .padding()
    }

    private var headerView: some View {
        HeaderTitleView(
            title: "평점을 설정해 주세요.",
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }

    private var ratingView: some View {
        StarView(starViewStyle: .auto(), rating: $rating)
            .frame(height: 100)
            .background(Color.contentsBackground1)
            .defaultCornerRadius()
    }

    private var bottomButtonView: some View {
        BottomButtonView(title: "저장하기") {
            bottomSheetPosition = .hidden
        }
    }
}
