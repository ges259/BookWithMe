//
//  CustomPrefsAlert.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import SwiftUI
import BottomSheet

struct CustomPrefsAlert: View {
    @Bindable var viewModel: CustomPrefsAlertViewModel
    
    
    var body: some View {
        VStack(spacing: 10) {
            self.headerView
            ScrollView {
                self.optionButtons
            }
            .frame(maxHeight: UIScreen.main.bounds.height * 0.6)
            .fixedSize(horizontal: false, vertical: true)
        }
        .background(Color.baseButton)
        .padding(.horizontal)
        .padding(.bottom, 10)
        .onDisappear {
            self.viewModel.save()
        }
    }
}



// MARK: - UI
private extension CustomPrefsAlert {
    /// UI - 테이블의 헤더 역할
    var headerView: some View {
        HeaderTitleView(
            title: viewModel.type.title,
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }
    @ViewBuilder
    var optionButtons: some View {
        switch viewModel.type {
        case .language:
            multiSelectOptionButtons(
                for: LanguageOption.allCases,
                selected: self.viewModel.prefs.language
            )
        case .pageLength:
            multiSelectOptionButtons(
                for: PageLength.allCases,
                selected: self.viewModel.prefs.pageLength
            )
        case .ageGroup:
            multiSelectOptionButtons(
                for: AgeGroup.allCases,
                selected: self.viewModel.prefs.ageGroup
            )
        case .readingPurpose:
            multiSelectOptionButtons(
                for: ReadingPurpose.allCases,
                selected: self.viewModel.prefs.readingPurpose
            )
        case .likedGenres:
            multiSelectOptionButtons(
                for: BookGenre.allCases,
                selected: self.viewModel.prefs.likedGenres
            )
        case .dislikedGenres:
            multiSelectOptionButtons(
                for: BookGenre.allCases,
                selected: self.viewModel.prefs.dislikedGenres
            )
        }
    }
}



// MARK: - Toggle
private extension CustomPrefsAlert {
    func multiSelectOptionButtons<Option: PrefsOption>(
        for all: [Option],
        selected selectedList: [Option]
    ) -> some View {
        LazyVStack(spacing: 5) {
            ForEach(all) { option in
                Button {
                    viewModel.toggle(option)
                } label: {
                    Text(option.label)
                        .frame(maxWidth: .infinity)
                        .frame(height: 45)
                        .background(
                            selectedList.contains(option)
                            ? Color.contentsBackground2
                            : Color.contentsBackground1
                        )
                        .cornerRadius(8)
                }
                .buttonStyle(.plain)
                .foregroundStyle(Color.black)
            }
        }
    }
}
