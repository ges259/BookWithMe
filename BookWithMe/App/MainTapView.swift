//
//  MainTapView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct MainTapView: View {
    let bookShelfView = BookShelfView(
        viewModel: BookShelfViewModel(
            coreDataManager: CoreDataManager.shared)
    )
    let readingHistoryView = ReadingHistoryView(
        viewModel: ReadingHistoryViewModel(
            coreDataManager: CoreDataManager.shared)
    )
    let searchView = SearchView()
    let analyticsView = AnalyticsView()
    let setttingView = SettingView()
    
    var body: some View {
        TabView {
            self.bookShelfView
                .tabItem { Image.bookShelf }
                .tag(0)
                
            self.readingHistoryView
                .tabItem { Image.readingHistroy }
                .tag(1)
            
            self.searchView
                .tabItem { Image.search }
                .tag(2)
            
            self.analyticsView
                .tabItem { Image.analytics }
                .tag(3)
            
            self.setttingView
                .tabItem { Image.setting }
                .tag(4)
        }
        .tint(Color.baseButton)
    }
}

#Preview {
    MainTapView()
}
