//
//  ConfirmationType.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import SwiftUI

enum ConfirmationType {
    case none
    case deleteBook(action: () -> Void)
    case unsavedChanges(action: () -> Void)
    case custom(
        title: String,
        message: String?,
        confirmTitle: String,
        confirmColor: Color = .red, action: () -> Void
    )

    var title: String {
        switch self {
        case .none: return ""
        case .deleteBook: return "책 삭제"
        case .unsavedChanges: return "수정 사항이 있어요"
        case .custom(let title, _, _, _, _): return title
        }
    }

    var message: String? {
        switch self {
        case .none: return ""
        case .deleteBook: return "정말 이 책을 삭제하시겠습니까?"
        case .unsavedChanges: return "변경된 내용을 저장하지 않고 나가시겠어요?"
        case .custom(_, let message, _, _, _): return message
        }
    }

    var confirmTitle: String {
        switch self {
        case .none: return ""
        case .deleteBook: return "삭제"
        case .unsavedChanges: return "나가기"
        case .custom(_, _, let title, _, _): return title
        }
    }

    var confirmColor: Color {
        switch self {
        case .none: return Color.clear
        case .deleteBook: return .red
        case .unsavedChanges: return .primary
        case .custom(_, _, _, let color, _): return color
        }
    }

    var action: () -> Void {
        switch self {
        case .deleteBook(let action),
                .unsavedChanges(let action),
                .custom(_, _, _, _, let action):
            return action
            
        case .none:
            return {}
        }
    }
}
