//
//  SettingView.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import SwiftUI

struct SettingView: View {
    var viewModel: SettingViewModel
    var nickname: String = "홍길동"
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                sectionList()
            }
            .padding()
        }
        .scrollDisabled(true)
    }
}

private extension SettingView {
    func sectionList() -> some View {
        ForEach(viewModel.sections, id: \.self) { section in
            sectionView(section)
        }
    }
    
    func sectionView(_ section: SettingSection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(section.rawValue)
                .frame(height: 35)
                .font(.headline)
            
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
        HStack {
            Text(item.title)
                .font(.system(size: 13))
            Spacer()
            Button(action: {
                handleAction(for: item)
            }) {
                accessoryView(for: item)
            }
            .frame(height: 35)
        }
    }

    // 액션 처리
    func handleAction(for item: SettingItem) {
        switch item {
        case .changeImage:
            print("이미지 변경")
        case .changeNickname:
            print("닉네임 변경")
        case .logout:
            print("로그아웃")
        case .deleteAccount:
            print("회원탈퇴")
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
