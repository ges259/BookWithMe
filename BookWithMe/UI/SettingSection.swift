//
//  SettingSection.swift
//  BookWithMe
//
//  Created by 계은성 on 5/7/25.
//

import Foundation

enum SettingSection: String, CaseIterable {
    case profile = "프로필 설정"
    case account = "계정 설정"
    
    var items: [SettingItem] {
        switch self {
        case .profile:
            return [.changeImage, .changeNickname]
        case .account:
            return [.logout, .deleteAccount]
        }
    }
}

enum SettingItem {
    case changeImage
    case changeNickname
    case logout
    case deleteAccount

    var title: String {
        switch self {
        case .changeImage: return "이미지 변경"
        case .changeNickname: return "닉네임 변경"
        case .logout: return "로그아웃"
        case .deleteAccount: return "회원탈퇴"
        }
    }
}
