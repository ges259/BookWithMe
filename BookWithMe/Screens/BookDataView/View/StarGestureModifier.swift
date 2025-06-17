//
//  StarGestureModifier.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import SwiftUI

// MARK: - StarGestureModifier
/// 별점을 터치하거나 드래그로 조절할 수 있게 만들어주는 Modifier.
/// 제스처를 쓸지 여부는 StarViewStyle에서 결정함.
struct StarGestureModifier: ViewModifier {
    let geometry: GeometryProxy
    let starViewStyle: StarViewStyle
    @Binding var rating: Double

    init(
        geometry: GeometryProxy,
        starViewStyle: StarViewStyle,
        rating: Binding<Double>
    ) {
        self.geometry = geometry
        self.starViewStyle = starViewStyle
        self._rating = rating
    }

    // 실제 뷰에 modifier를 적용하는 부분
    func body(content: Content) -> some View {
        // 스타일에서 제스처 사용 여부가 true일 때만 drag 제스처 적용
        if starViewStyle.useGesture {
            content.gesture(dragGesture)
        } else {
            content
        }
    }
}


// 별점 계산에 필요한 여러 값들을 따로 정리해놓은 extension.
// 보기 좋고 계산도 깔끔하게 되도록 따로 뺐음.
private extension StarGestureModifier {
    
    /// 별 사이 간격의 총합 (spacing * (별 개수 - 1))
    var totalSpacing: CGFloat {
        starViewStyle.spacing * CGFloat(starViewStyle.maxRating - 1)
    }

    /// 전체 가로 폭에서 좌우 padding과 spacing을 뺀 실제 별이 들어갈 수 있는 너비
    var availableWidth: CGFloat {
        geometry.size.width - starViewStyle.horizontalPadding * 2 - totalSpacing
    }

    /// 별 하나당 크기 (음수 되면 안 되니까 max(0, ...) 처리)
    var starSize: CGFloat {
        max(0, availableWidth / CGFloat(starViewStyle.maxRating))
    }

    /// 별 전체 너비 (별 너비 + 간격 포함)
    var totalStarWidth: CGFloat {
        availableWidth + totalSpacing
    }

    /// 전체 Geometry 기준의 컨테이너 너비
    var containerWidth: CGFloat {
        geometry.size.width
    }
}


// 실제 드래그 제스처 처리 부분
private extension StarGestureModifier {
    var dragGesture: some Gesture {
        DragGesture(minimumDistance: 0) // 살짝만 눌러도 바로 반응
            .onChanged { value in
                // 별 UI가 중앙에 배치되기 때문에 좌측 여백 보정
                let horizontalOffset = (containerWidth - totalStarWidth) / 2
                let localX = value.location.x - horizontalOffset // 제스처 위치에서 보정값 빼기
                
                // 범위 밖이면 무시
                guard localX >= 0, localX <= totalStarWidth else { return }

                // 별 위치 기준으로 몇 번째 별인지 계산
                let rawRating = (localX + starViewStyle.spacing / 2) / (starSize + starViewStyle.spacing)
                let newRating = (rawRating * 2).rounded() / 2 // 0.5 단위로 반올림

                // 값이 달라졌을 때만 업데이트
                if newRating != rating {
                    rating = newRating
                }
            }
    }
}
