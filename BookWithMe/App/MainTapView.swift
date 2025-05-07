//
//  MainTapView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct MainTapView: View {
    var body: some View {
        NavigationStack {
            TabView {
                ForEach(TabItem.allCases, id: \.tag) { tabItem in
                    tabItem.view
                        .background(Color.baseBackground)
                        .navigationBarTitleDisplayMode(.inline)
                        .tabItem {
                            tabItem.iconImage
                            Text(tabItem.navTitle.isEmpty ? " " : tabItem.navTitle)
                        }
                        .tag(tabItem.tag)
                        .navigationTitle(tabItem.navTitle)
                    
                }
            }
            .tint(Color.baseButton)
            .foregroundColor(Color.black)
        }
    }
}

private enum TabItem: CaseIterable {
    case bookShelf
    case readingHistory
    case search
    case analytics
    case setting
    
    var tag: Int {
        switch self {
        case .bookShelf: return 0
        case .readingHistory: return 1
        case .search: return 2
        case .analytics: return 3
        case .setting: return 4
        }
    }
    
    var iconImage: Image {
        switch self {
        case .bookShelf: return Image.bookShelf
        case .readingHistory: return Image.readingHistroy
        case .search: return Image.search
        case .analytics: return Image.analytics
        case .setting: return Image.setting
        }
    }
    
    @ViewBuilder
    var view: some View {
        switch self {
        case .bookShelf:
            BookShelfView(
                viewModel: BookShelfViewModel(
                    coreDataManager: CoreDataManager.shared
                )
            )
        case .readingHistory:
            ReadingHistoryView(
                viewModel: ReadingHistoryViewModel(
                    coreDataManager: CoreDataManager.shared
                )
            )
        case .search:
            SearchView()
        case .analytics:
            AnalyticsView()
        case .setting:
            SettingView(viewModel: SettingViewModel())
        }
    }
    
    
    var navTitle: String {
        switch self {
        case .bookShelf: return ""
        case .readingHistory: return "나의 독서 기록"
        case .search: return "검색"
        case .analytics: return "통계"
        case .setting: return "설정"
        }
    }
}

#Preview {
    MainTapView()
}
