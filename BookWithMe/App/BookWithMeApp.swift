//
//  BookWithMeApp.swift
//  BookWithMe
//
//  Created by 계은성 on 5/4/25.
//

import SwiftUI

@main
struct BookWithMeApp: App {
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
            ContentView()
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
//        UITabBar.appearance().compactAppearance = appearance
    }

}
