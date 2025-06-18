//
//  ReadingHistoryView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

// MARK: - PagingTabView
struct PagingTabView: View {
    /// 현재 보고 있는 페이지 인덱스를 외부에서 바인딩
    @Binding var currentPage: Int
    /// 드래그 제스처로 인한 offset 값
    @State private var offset = CGFloat.zero
    
    
    /// 각 페이지에 보여질 뷰들을 담은 클로저
    let views: () -> [AnyView]
    /// 총 페이지 수
    private var pageCount: Int { views().count }
    
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Constants.pageSpacing) {
            pageContentView // 실제 페이지 컨텐츠를 보여주는 뷰
            pageIndicatorView // 현재 페이지를 나타내는 동그라미들 뷰
        }
    }
}


private extension PagingTabView {
    // MARK: - UI
    /// 실제 페이지 컨텐츠를 보여주는 뷰
    var pageContentView: some View {
        GeometryReader { geo in
            // 각 페이지의 너비 계산 (전체 너비 * 비율)
            let pageWidth = geo.size.width * Constants.pageWidthRatio
            
            LazyHStack(spacing: Constants.pageSpacing) {
                // 첫 번째 페이지 앞에 공간 만들어서 이전 페이지 살짝 보이게 함
                leadingSpacingView(parentWidth: geo.size.width)
                // 각 페이지에 해당하는 뷰를 순회하면서 보여줌
                ForEach(0..<pageCount, id: \.self) { index in
                    views()[index]
                        .frame(width: pageWidth) // 각 페이지 뷰의 너비 설정
                        .padding(.vertical) // 상하 여백 줌
                }
            }
            // LazyHStack의 offset 조절해서 현재 페이지 가운데 맞추고 드래그 따라 움직이게 함
            .offset(x: calculateOffset(pageWidth: pageWidth))
            // currentPage 바뀔 때마다 애니메이션 적용
            .animation(.easeOut, value: currentPage)
            // 드래그 제스처 감지해서 페이지 바꾸는 로직 처리
            .gesture(pageDragGesture())
        }
    }
    
    /// 첫 번째 페이지 앞에 공간 만들어서 이전 페이지 살짝 보이게 하는 뷰
    func leadingSpacingView(parentWidth: CGFloat) -> some View {
        Color.clear
        // 화면 너비에 leadingSpacingRatio 곱한 값에서 spacing 뺀 만큼 너비 가짐 (음수면 0)
            .frame(width: max(parentWidth * Constants.leadingSpacingRatio - Constants.pageSpacing, 0)
            )
    }
    
    /// 현재 offset 값 계산하는 함수
    func calculateOffset(pageWidth: CGFloat) -> CGFloat {
        // 현재 페이지 인덱스 기준으로 offset 계산해서 페이지 중앙으로 이동시키고, 드래그 offset 더함
        CGFloat(-currentPage) * (pageWidth + Constants.pageSpacing) + offset
    }
    
    
    // MARK: - Drag
    /// 드래그 제스처 처리하는 함수
    func pageDragGesture() -> some Gesture {
        DragGesture()
        // 드래그 값 변할 때마다 offset 업데이트
            .onChanged { value in
                offset = value.translation.width
            }
        // 드래그 끝나면 페이지 바꾸는 로직 처리
            .onEnded { value in
                withAnimation(.easeOut) {
                    // 오른쪽으로 50 넘게 드래그했으면 이전 페이지로
                    if offset > Constants.dragThreshold {
                        currentPage = max(0, currentPage - 1)
                    }
                    // 왼쪽으로 -50 넘게 드래그했으면 다음 페이지로
                    else if offset < -Constants.dragThreshold {
                        currentPage = min(pageCount - 1, currentPage + 1)
                    }
                    // offset 초기화
                    offset = 0
                }
            }
    }
    
    
    // MARK: - Indicator
    /// 현재 페이지 나타내는 동그라미들 뷰
    var pageIndicatorView: some View {
        HStack {
            // 총 페이지 수만큼 동그라미 생성
            ForEach(0..<pageCount, id: \.self) { index in
                
                Circle()
                // 인디케이터 크기 설정
                    .frame(width: Constants.indicatorSize)
                // 현재 페이지 인덱스랑 같으면 primary 색, 아니면 secondary 색에 투명도 적용
                    .foregroundColor(
                        index == currentPage
                        ? .primary
                        : .secondary.opacity(
                            Constants.indicatorOpacity)
                    )
                    .padding(.bottom, Constants.indicatorBottomPadding)
                // 탭하면 해당 인덱스로 현재 페이지 업데이트
                    .onTapGesture {
                        currentPage = index
                    }
            }
        }
    }
}


// MARK: - Constants
private extension PagingTabView {
    enum Constants {
        // 각 페이지가 화면 너비의 몇 배를 차지할지 비율
        static let pageWidthRatio: CGFloat = 0.8
        // 첫 번째 페이지 앞에 둘 공간 비율
        static let leadingSpacingRatio: CGFloat = 0.1
        // 페이지 인디케이터 크기
        static let indicatorSize: CGFloat = 15
        // 선택 안 된 페이지 인디케이터 투명도
        static let indicatorOpacity: Double = 0.5
        // 페이지 사이 기본 간격
        static let pageSpacing: CGFloat = 20
        // 인디케이터 아래 여백
        static let indicatorBottomPadding: CGFloat = 30
        // 드래그 시 페이지 전환 임계값
        static let dragThreshold: CGFloat = 50
    }
}
