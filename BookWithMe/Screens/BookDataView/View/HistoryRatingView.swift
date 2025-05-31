//
//  HistoryRatingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI
import BottomSheet

struct HistoryRatingView: View {
    private enum Constants {
        static let maxRating = 5  // 별 개수는 5개로 설정
        static let spacing: CGFloat = 15  // 별 사이 간격은 15pt로 설정
        static let ratingHStackHorizontalPadding: Double = 20 // 좌우 여백은 20pt로 설정
        static let ratingViewHeight: CGFloat = 100 // 전체 별점 뷰 높이는 100pt로 설정
    }
    @Binding var bottomSheetPosition: BottomSheetPosition
    @Binding var rating: Double
    
    @State private var starSize: CGFloat = 0
    @State private var totalStarWidth: CGFloat = 0
    @State private var startX: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 10) {
            self.headerView
            self.ratingView
            self.bottomButtonView
        }
        .padding()
        .onAppear {
            // 뷰가 나타날 때 starSize 계산
            self.calculateStarSizeForWidth()
        }
    }
}

// MARK: - UI
private extension HistoryRatingView {
    var headerView: some View {
        return HeaderTitleView(
            title: "평점을 설정해 주세요.",
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }
    
    var bottomButtonView: some View {
        return BottomButtonView(title: "저장하기") {
            self.bottomSheetPosition = .hidden
        }
    }
    
    var ratingView: some View {
        GeometryReader { geometry in
            self.starStack
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height / 2)
                .contentShape(Rectangle())
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            let location = value.location.x - self.startX
                            
                            if location >= 0
                                && location <= self.totalStarWidth
                            {
                                
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
    
    var starStack: some View {
        HStack(spacing: Constants.spacing) {
            ForEach(0..<Constants.maxRating, id: \.self) { index in
                self.starImage(for: index, starSize: starSize)
                    .resizable()
                    .foregroundColor(.baseButton)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: starSize, height: starSize)
            }
        }
        .padding(.horizontal, Constants.ratingHStackHorizontalPadding)
        .frame(maxHeight: .infinity)
        .background(Color.contentsBackground1)
    }
    
    func starImage(for index: Int, starSize: CGFloat) -> Image {
        let threshold = Double(index) + 1
        if rating >= threshold {
            return Image.starFill
        } else if rating + 0.5 >= threshold {
            return Image.starHalf
        } else {
            return Image.starEmpty
        }
    }
    
    // starSize 계산 함수
    func calculateStarSizeForWidth() {
        // 화면의 너비 구하기
        // 50은 별 반개에서 한 개로 넘어가는 비율 (왜 50인지는 잘 모르겠음. 일단 잘 작동함)
        let width = UIScreen.main.bounds.width - CGFloat(50)
        
        let calculatedStarSize = calculateStarSizeFromWidth(from: width)
        let calculatedTotalWidth = calculateTotalStarWidth(starSize: calculatedStarSize)
        let calculatedStartX = (width - calculatedTotalWidth) / CGFloat(2) + CGFloat(Constants.ratingHStackHorizontalPadding)
        
        // @State로 상태 업데이트
        self.starSize = calculatedStarSize
        self.totalStarWidth = calculatedTotalWidth
        self.startX = calculatedStartX
    }
    
    // 별 하나의 크기 계산 함수
    func calculateStarSizeFromWidth(from width: CGFloat) -> CGFloat {
        let availableWidth = width
            - Constants.spacing * 4
            - Constants.ratingHStackHorizontalPadding * 2
        
        return availableWidth / CGFloat(Constants.maxRating)
    }

    // 전체 별들의 총 너비 계산
    func calculateTotalStarWidth(starSize: CGFloat) -> CGFloat {
        return CGFloat(Constants.maxRating) * starSize
            + Constants.spacing * CGFloat(Constants.maxRating - 1)
            + Constants.ratingHStackHorizontalPadding * 2
    }
}
