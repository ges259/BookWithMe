//
//  HistoryRatingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI

struct HistoryRatingView: View {
    private enum Constants {
        static let maxRating = 5  // 최대 별 개수 (5개로 설정)
        static let spacing: CGFloat = 15  // 별 사이의 간격 (10pt)
        static let starStep: Double = 0.5  // 별점 단위 (0.5 단위)
        static let starFull: Double = 1.0  // 별 하나의 전체 값 (1.0)
        static let ratingHStackHorizontalPadding: Double = 20 // 별 하나의 전체 값 (1.0)
        static let ratingViewHeight: CGFloat = 100
    }
    
    // 현재 별점 값 (0부터 5까지, 0.5 단위로)
    @State private var rating: Double = 0

    var body: some View {
        VStack(spacing: 10) {
            self.headerView
            self.ratingView
            self.bottomButtonView
        }
        .padding()
    }

    private func starImage(for index: Int, starSize: CGFloat) -> Image {
        let threshold = Double(index) + 1
        if rating >= threshold {
            return Image(systemName: "star.fill")
        } else if rating + 0.5 >= threshold {
            return Image(systemName: "star.leadinghalf.filled")
        } else {
            return Image(systemName: "star")
        }
    }
}



// MARK: - UI
private extension HistoryRatingView {
    var headerView: some View {
        return HeaderTitleView(
            title: "평점을 설정해 주세요.",
            appFont: .historyHeaderViewFont,
            showChevron: false,
            alignment: .center
        )
    }
    
    var bottomButtonView: some View {
        return BottomButtonView(title: "저장하기") {
            print("HistoryRatingView_bottomButton")
        }
    }
    
    var ratingView: some View {
        GeometryReader { geometry in
            let starSize = self.calculateStarSize(from: geometry.size.width)
            let totalStarWidth = self.calculateTotalStarWidth(starSize: starSize)
            let startX = (geometry.size.width - totalStarWidth) / 2 + CGFloat(Constants.ratingHStackHorizontalPadding)

            self.starStack(starSize: starSize)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height / 2)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let location = value.location.x - startX
                            if location >= 0 && location <= totalStarWidth {
                                let rawRating = (location + Constants.spacing / 2) / (starSize + Constants.spacing)
                                let newRating = (rawRating * 2).rounded() / 2
                                if newRating != self.rating {
                                    self.rating = newRating
                                }
                            }
                        }
                )
        }
        .frame(height: Constants.ratingViewHeight)
        .background(Color.contentsBackground1)
        .defaultCornerRadius()
    }
    
    
    private func starStack(starSize: CGFloat) -> some View {
        HStack(spacing: Constants.spacing) {
            ForEach(0..<Constants.maxRating, id: \.self) { index in
                self.starImage(for: index, starSize: starSize)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: starSize, height: starSize)
            }
        }
        .padding(.horizontal, Constants.ratingHStackHorizontalPadding)
        .frame(maxHeight: .infinity)
        .background(Color.red)
    }
    
    private func calculateStarSize(from width: CGFloat) -> CGFloat {
        let availableWidth =
        width
        - Constants.spacing * 4
        - Constants.ratingHStackHorizontalPadding * 2
        
        return availableWidth / CGFloat(Constants.maxRating)
    }

    private func calculateTotalStarWidth(starSize: CGFloat) -> CGFloat {
        return CGFloat(Constants.maxRating)
        * starSize
        + Constants.spacing
        * CGFloat(Constants.maxRating - 1)
        + Constants.ratingHStackHorizontalPadding * 2
    }
}
