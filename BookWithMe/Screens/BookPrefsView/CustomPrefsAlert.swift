//
//  CustomPrefsAlert.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import SwiftUI
import BottomSheet

struct CustomPrefsAlert: View {
    let type: CustomPrefsType
    @Binding var bottomSheetPosition: BottomSheetPosition

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 10) {
                    headerView
                    optionButtons
                    bottomButtonView
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(Color.baseButton)
        .padding(.horizontal)
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
            bottomSheetPosition = .hidden
        }
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
        VStack(spacing: 5) {
            ForEach(all) { option in
                Button {
                    selectionAction(option)
                    bottomSheetPosition = .hidden
                    
                } label: {
                    Text(option.label)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.contentsBackground1)
                .foregroundStyle(Color.black)
            }
        }
    }
}

//#Preview {
//    CustomPrefsAlert(type: .ageGroup, bottomSheetPosition: <#Binding<BottomSheetPosition>#>)
//}
