//
//  TabItem.swift
//  BookWithMe
//
//  Created by 계은성 on 5/8/25.
//

import SwiftUI

enum TabItem: CaseIterable, Hashable {
    case bookShelf, readingHistory, search, setting
    // , analytics
    var iconImage: Image {
        switch self {
        case .bookShelf: return Image.bookShelf
        case .readingHistory: return Image.readingHistroy
        case .search: return Image.search
//        case .analytics: return Image.analytics
        case .setting: return Image.setting
        }
    }

    var navTitle: String {
        switch self {
        case .bookShelf: return " "
        case .readingHistory: return "나의 독서 기록"
        case .search: return "검색"
//        case .analytics: return "통계"
        case .setting: return "설정"
        }
    }

    @ViewBuilder
    var view: some View {
        switch self {
        case .bookShelf:
            BookShelfView(viewModel: BookShelfViewModel())
        case .readingHistory:
            ReadingHistoryView(viewModel: ReadingHistoryViewModel(coreDataManager: CoreDataManager.shared))
        case .search:
            SearchView()
//        case .analytics:
//            AnalyticsView()
        case .setting:
            SettingView(viewModel: SettingViewModel())
        }
    }
}
