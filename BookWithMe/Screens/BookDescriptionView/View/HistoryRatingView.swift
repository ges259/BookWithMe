//
//  HistoryRatingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/10/25.
//

import SwiftUI

struct HistoryRatingView: View {
    private enum Constants {
        static let maxRating = 5  // 별 개수는 5개로 설정
        static let spacing: CGFloat = 15  // 별 사이 간격은 15pt로 설정
        static let ratingHStackHorizontalPadding: Double = 20 // 좌우 여백은 20pt로 설정
        static let ratingViewHeight: CGFloat = 100 // 전체 별점 뷰 높이는 100pt로 설정
    }
    
    // 현재 선택된 별점 값을 저장할 State 변수 (0부터 5까지, 0.5 단위 값으로)
    @Binding var rating: Double

    var body: some View {
        VStack(spacing: 10) {
            self.headerView  // 위쪽 제목 뷰
            self.ratingView  // 중간에 별점 표시 뷰
            self.bottomButtonView  // 아래쪽 저장 버튼 뷰
        }
        .padding()
    }
}

// MARK: - UI
private extension HistoryRatingView {
    // 상단 제목 뷰
    var headerView: some View {
        return HeaderTitleView(
            title: "평점을 설정해 주세요.",
            appFont: .historyHeaderViewFont,
            showChevron: false,
            alignment: .center
        )
    }
    
    // 하단 버튼 뷰
    var bottomButtonView: some View {
        return BottomButtonView(title: "저장하기") {
            print("HistoryRatingView_bottomButton")
        }
    }

    // 별점 보여주는 뷰
    var ratingView: some View {
        GeometryReader { geometry in
            // 전체 너비에서 별 크기 계산
            let starSize = self.calculateStarSize(from: geometry.size.width)
            // 전체 별들의 너비 계산 (간격 포함해서)
            let totalStarWidth = self.calculateTotalStarWidth(starSize: starSize)
            // 사용자의 터치 시작 위치 기준 x좌표 계산
            let startX = (geometry.size.width - totalStarWidth) / 2 + CGFloat(Constants.ratingHStackHorizontalPadding)

            self.starStack(starSize: starSize)
                .position(x: geometry.size.width / 2,
                          y: geometry.size.height / 2)  // 가운데 정렬
                .contentShape(Rectangle())  // 제스처 범위를 전체로 설정
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            // 현재 터치 위치에서 시작 위치를 뺀 상대 좌표
                            let location = value.location.x - startX
                            // 터치가 유효 범위 내일 때만 처리
                            if location >= 0 && location <= totalStarWidth {
                                // 위치에 따라 별점 계산 (0.5 단위로 반올림)
                                let rawRating = (location + Constants.spacing / 2) / (starSize + Constants.spacing)
                                let newRating = (rawRating * 2).rounded() / 2
                                // 값이 바뀐 경우에만 반영
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
    
    // 별을 HStack으로 나열한 뷰
    func starStack(starSize: CGFloat) -> some View {
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
    
    // 별 이미지 결정하는 함수
    func starImage(for index: Int, starSize: CGFloat) -> Image {
        let threshold = Double(index) + 1
        // 별을 다 채운 상태일 때
        if rating >= threshold {
            return Image.starFill
            
            // 반만 채운 별일 때
        } else if rating + 0.5 >= threshold {
            return Image.starHalf
            
            // 아직 안 채워진 별일 때
        } else {
            return Image.starEmpty
        }
    }
    
    // 별 하나의 크기를 전체 너비에서 계산하는 함수
    func calculateStarSize(from width: CGFloat) -> CGFloat {
        let availableWidth =
        width
        - Constants.spacing * 4  // 별 사이 간격 합산
        - Constants.ratingHStackHorizontalPadding * 2  // 좌우 여백 포함

        // 별 개수로 나눈 값으로 설정
        return availableWidth / CGFloat(Constants.maxRating)
    }

    // 전체 별들의 총 너비를 계산하는 함수
    func calculateTotalStarWidth(starSize: CGFloat) -> CGFloat {
        return CGFloat(Constants.maxRating)
        * starSize
        + Constants.spacing
        * CGFloat(Constants.maxRating - 1)
        + Constants.ratingHStackHorizontalPadding * 2
    }
}
