//
//  BookWithMeApp.swift
//  BookWithMe
//
//  Created by 계은성 on 5/4/25.
//

import SwiftUI

@main
struct BookWithMeApp: App {
    // 1) 스플래시 표시용 상태
    @State private var showSplash = true

    init() {
        let backgroundColor = UIColor(
               red: 204 / 255.0,
               green: 224 / 255.0,
               blue: 255 / 255.0,
               alpha: 1.0
           )
        self.setupTabBarAppearance(backgroundColor)
        self.setupNavigationBarAppearance(backgroundColor)
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                // 메인 콘텐츠
                ContentView()
                    .opacity(showSplash ? 0 : 1)

                // 스플래시 뷰
                if showSplash {
                    SplashView()
                }
            }
            .onAppear {
                // 1) 데이터 로드 완료 시점에 스플래시 숨기기
                Task {
                    // 예: BookCache에 데이터 로드 위임
                    await BookCache.shared.loadInitialData()
                    // 2) 로딩 끝나면 애니메이션과 함께 사라지게
                    withAnimation(.easeOut(duration: 0.5)) {
                        showSplash = false
                    }
                }
            }
        }
    }
    
    
    
    
    
    // MARK: - Appearance Setup Methods
    private func setupNavigationBarAppearance(_ backgroundColor: UIColor) {
        let appearance = UINavigationBarAppearance()

        // 불투명한 배경 설정 (배경색과 그림자색 적용을 위해)
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = backgroundColor

        // 모든 네비게이션 바 스타일에 appearance 적용
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
    }

    private func setupTabBarAppearance(_ backgroundColor: UIColor) {

        let appearance = UITabBarAppearance()

        // 불투명한 배경 설정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = backgroundColor
        appearance.shadowColor = backgroundColor

        // 모든 탭 바 스타일에 appearance 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
}





struct SplashView: View {
    var body: some View {
        Rectangle()
            .foregroundColor(Color.baseBackground)
            .ignoresSafeArea()
    }
}
