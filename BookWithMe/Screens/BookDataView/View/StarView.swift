//
//  StarView.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import SwiftUI

// MARK: - StarView
/// 별점을 보여주는 뷰.
/// 스타일에 따라 높이, 정렬, 제스처 사용 여부 등을 설정할 수 있음.
struct StarView: View {
    let starViewStyle: StarViewStyle
    
    @Binding var rating: Double // 현재 별점 (0 ~ maxRating, 0.5 단위 가능)

    var body: some View {
        GeometryReader { geometry in
            // 별을 수평으로 배치함 (간격은 스타일에서 설정)
            HStack(alignment: .center, spacing: starViewStyle.spacing) {
                // maxRating만큼 반복해서 별 이미지를 표시함
                ForEach(0..<starViewStyle.maxRating, id: \.self) { index in
                    starType(for: index) // 별 타입 결정 (full/half/empty)
                        .image // enum에서 이미지 리턴
                        .resizable() // 크기 조절 가능하게
                        .foregroundColor(.baseButton) // 색상 설정
                        .aspectRatio(contentMode: .fit) // 비율 유지하며 꽉 채우기
                }
            }
            .padding(.horizontal, starViewStyle.horizontalPadding) // 좌우 여백
            .frame(maxHeight: .infinity) // 높이는 부모에 맞게 최대한
            .contentShape(Rectangle()) // 제스처 인식 범위를 사각형으로 설정
            .modifier(
                // 드래그 제스처용 modifier. 스타일에 따라 적용 여부 결정됨
                StarGestureModifier(
                    geometry: geometry,
                    starViewStyle: self.starViewStyle,
                    rating: $rating
                )
            )
        }
        .frame(height: starViewStyle.height) // 높이 지정되어 있으면 적용 (없으면 자동)
    }

    /// 현재 인덱스에 해당하는 별의 타입을 반환함
    /// 예: rating이 3.5일 때 -> [full, full, full, half, empty]
    private func starType(for index: Int) -> StarType {
        let threshold = Double(index) + 1
        if rating >= threshold {
            return .full
        } else if rating + 0.5 >= threshold {
            return .half
        } else {
            return .empty
        }
    }
}
