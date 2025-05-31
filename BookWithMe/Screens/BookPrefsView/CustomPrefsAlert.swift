//
//  CustomPrefsAlert.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import SwiftUI

struct CustomPrefsAlert: View {
    let type: CustomPrefsType
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        
        VStack(spacing: 5) {
            headerView
            optionButtons
                .padding(.horizontal)
            bottomButtonView
        }
        .background(Color.contentsBackground1)
        .padding(.bottom, 10)
    }
}

private extension CustomPrefsAlert {
    /// UI - 테이블의 헤더 역할
    var headerView: some View {
        HeaderTitleView(
            title: type.title,
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }

    var bottomButtonView: some View {
        BottomButtonView(title: "저장하기") {
            dismiss()
        }
        .padding(.horizontal)
    }

    @ViewBuilder
    var optionButtons: some View {
        switch type {
        case .language:
            prefsOptionButtons(for: LanguageOption.allCases) { BookCache.shared.bookPrefs.language = $0 }
        case .pageLength:
            prefsOptionButtons(for: PageLength.allCases) { BookCache.shared.bookPrefs.pageLength = $0 }
        case .ageGroup:
            prefsOptionButtons(for: AgeGroup.allCases) { BookCache.shared.bookPrefs.ageGroup = $0 }
        case .readingPurpose:
            prefsOptionButtons(for: ReadingPurpose.allCases) { BookCache.shared.bookPrefs.readingPurpose = $0 }
        default:
            EmptyView()
        }
    }

    func prefsOptionButtons<Option: PrefsOption>(
        for all: [Option],
        selectionAction: @escaping (Option) -> Void
    ) -> some View {
        VStack(spacing: 12) {
            ForEach(all) { option in
                Button {
                    selectionAction(option)
                    dismiss()
                } label: {
                    Text(option.label)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }
}

#Preview {
    CustomPrefsAlert(type: .ageGroup)
}
