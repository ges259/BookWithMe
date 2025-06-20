//
//  SettingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct SettingView: View {
    var viewModel: SettingViewModel
    var nickname: String = ""
    
    var body: some View {
        ScrollView {
            sectionList()
        }
        .scrollDisabled(true)
    }
}

private extension SettingView {
    func sectionList() -> some View {
        LazyVStack(spacing: 10) {
            ForEach(viewModel.sections, id: \.self) { section in
                sectionView(section)
            }
        }
        .padding()
    }
    
    func sectionView(_ section: SettingSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.rawValue)
                .frame(height: 35)
                .font(.headline)
                .foregroundStyle(Color.black)
            
            // 섹션의 셀을 설정
            ForEach(section.items, id: \.title) { item in
                rowView(item)
            }
        }
        .padding()
        .background(Color.contentsBackground1)
        .cornerRadius(16)
        .defaultShadow()
    }

    func rowView(_ item: SettingItem) -> some View {
        NavigationLink {
            handleAction(for: item)
        } label: {
            HStack {
                Text(item.title)
                    .font(.system(size: 13))
                Spacer()
                accessoryView(for: item)
            }
            .foregroundStyle(Color.black)
        }
        .frame(height: 35)
    }

    // 액션 처리
    @ViewBuilder
    func handleAction(for item: SettingItem) -> some View {
        switch item {
        case .changeImage:
            EmptyView()
        case .changeNickname:
            EmptyView()
        case .logout:
            EmptyView()
        case .deleteAccount:
            EmptyView()
        case .bookPrefs:
            BookPrefsView(viewModel: BookPrefsViewModel(bookCache: BookCache.shared))
        }
    }

    // 액세서리 뷰 처리
    func accessoryView(for item: SettingItem) -> some View {
        switch item {
        case .changeImage:
            return AnyView(Image(systemName: "photo.fill"))
        case .changeNickname:
            return AnyView(Text(nickname)) // 실제 닉네임을 여기서 표시
        default:
            return AnyView(EmptyView())
        }
    }
}
