//
//  ReadingHistoryView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//

import SwiftUI

// MARK: - PagingTabViewConstants
private enum PagingTabViewConstants {
    static let pageWidthRatio: CGFloat = 0.8 // 각 페이지가 화면 너비의 몇 배를 차지할지 비율
    static let leadingSpacingRatio: CGFloat = 0.1 // 첫 번째 페이지 앞에 둘 공간 비율
    static let indicatorSize: CGFloat = 10 // 페이지 인디케이터 크기
    static let indicatorOpacity: Double = 0.5 // 선택 안 된 페이지 인디케이터 투명도
}




// MARK: - PagingTabView
struct PagingTabView: View {
    @Binding var currentPage: Int // 현재 보고 있는 페이지 인덱스를 외부에서 바인딩
    let spacing: CGFloat // 페이지들 사이의 간격
    let views: () -> [AnyView] // 각 페이지에 보여질 뷰들을 담은 클로저
    
    @State private var offset = CGFloat.zero // 드래그 제스처로 인한 offset 값
    private var pageCount: Int { views().count } // 총 페이지 수
    
    
    
    // MARK: - Body
    
    var body: some View {
        VStack(spacing: spacing) {
            pageContentView // 실제 페이지 컨텐츠를 보여주는 뷰
            pageIndicatorView // 현재 페이지를 나타내는 동그라미들 뷰
        }
    }
    
    
    
    // MARK: - Private Computed Properties
    /// 실제 페이지 컨텐츠를 보여주는 뷰
    private var pageContentView: some View {
        GeometryReader { geo in
            // 각 페이지의 너비 계산 (전체 너비 * 비율)
            let pageWidth = geo.size.width * PagingTabViewConstants.pageWidthRatio
            
            LazyHStack(spacing: spacing) {
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
    private func leadingSpacingView(parentWidth: CGFloat) -> some View {
        Color.clear
        // 화면 너비에 leadingSpacingRatio 곱한 값에서 spacing 뺀 만큼 너비 가짐 (음수면 0)
            .frame(width: max(parentWidth * PagingTabViewConstants.leadingSpacingRatio - spacing, 0)
            )
    }
    
    /// 현재 offset 값 계산하는 함수
    private func calculateOffset(pageWidth: CGFloat) -> CGFloat {
        // 현재 페이지 인덱스 기준으로 offset 계산해서 페이지 중앙으로 이동시키고, 드래그 offset 더함
        CGFloat(-currentPage) * (pageWidth + spacing) + offset
    }
    
    /// 드래그 제스처 처리하는 함수
    private func pageDragGesture() -> some Gesture {
        DragGesture()
        // 드래그 값 변할 때마다 offset 업데이트
            .onChanged { value in
                offset = value.translation.width
            }
        // 드래그 끝나면 페이지 바꾸는 로직 처리
            .onEnded { value in
                withAnimation(.easeOut) {
                    // 오른쪽으로 50 넘게 드래그했으면 이전 페이지로
                    if offset > 50 {
                        currentPage = max(0, currentPage - 1)
                    }
                    // 왼쪽으로 -50 넘게 드래그했으면 다음 페이지로
                    else if offset < -50 {
                        currentPage = min(pageCount - 1, currentPage + 1)
                    }
                    // offset 초기화
                    offset = 0
                }
            }
    }
    
    /// 현재 페이지 나타내는 동그라미들 뷰
    private var pageIndicatorView: some View {
        HStack {
            // 총 페이지 수만큼 동그라미 생성
            ForEach(0..<pageCount, id: \.self) { index in
                
                Circle()
                // 인디케이터 크기 설정
                    .frame(width: PagingTabViewConstants.indicatorSize)
                // 현재 페이지 인덱스랑 같으면 primary 색, 아니면 secondary 색에 투명도 적용
                    .foregroundColor(
                        index == currentPage 
                        ? .primary
                        : .secondary.opacity(
                            PagingTabViewConstants.indicatorOpacity)
                    )
                    .padding(.bottom, 30)
                // 탭하면 해당 인덱스로 현재 페이지 업데이트
                    .onTapGesture {
                        currentPage = index
                    }
                    
            }
        }
    }
}
