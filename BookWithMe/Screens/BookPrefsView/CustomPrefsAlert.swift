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
    
    // BookPrefsViewModel의 BookPrefs를 바인딩하여 관리
    @Binding var localPrefs: BookPrefs
    
    
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
            saveData()
        }
    }
    
    
    // MARK: - saveData
    private func saveData() {
        BookCache.shared.bookPrefs = localPrefs
    }
}



// MARK: - UI
private extension CustomPrefsAlert {
    /// UI - 테이블의 헤더 역할
    var headerView: some View {
        HeaderTitleView(
            title: type.title,
            appFont: .historyHeaderViewFont,
            alignment: .center
        )
    }
    @ViewBuilder
    var optionButtons: some View {
        switch type {
        case .language:
            multiSelectOptionButtons(
                for: LanguageOption.allCases,
                selected: localPrefs.language
            )
        case .pageLength:
            multiSelectOptionButtons(
                for: PageLength.allCases,
                selected: localPrefs.pageLength
            )
        case .ageGroup:
            multiSelectOptionButtons(
                for: AgeGroup.allCases,
                selected: localPrefs.ageGroup
            )
        case .readingPurpose:
            multiSelectOptionButtons(
                for: ReadingPurpose.allCases,
                selected: localPrefs.readingPurpose
            )
        case .likedGenres:
            multiSelectOptionButtons(
                for: BookGenre.allCases,
                selected: localPrefs.likedGenres
            )
        case .dislikedGenres:
            multiSelectOptionButtons(
                for: BookGenre.allCases,
                selected: localPrefs.dislikedGenres
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
                    toggle(option, in: all)
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
    
    func toggle<Option: PrefsOption>(
        _ option: Option,
        in all: [Option]
    ) {
        switch type {
        case .language:
            if let opt = option as? LanguageOption {
                toggleOption(opt, &localPrefs.language)
            }
        case .pageLength:
            if let opt = option as? PageLength {
                toggleOption(opt, &localPrefs.pageLength)
            }
        case .ageGroup:
            if let opt = option as? AgeGroup {
                toggleOption(opt, &localPrefs.ageGroup)
            }
        case .readingPurpose:
            if let opt = option as? ReadingPurpose {
                toggleOption(opt, &localPrefs.readingPurpose)
            }
        case .likedGenres:
            if let opt = option as? BookGenre {
                toggleGenre(
                    option: opt,
                    from: \.likedGenres,
                    removingFrom: \.dislikedGenres
                )
            }
        case .dislikedGenres:
            if let opt = option as? BookGenre {
                toggleGenre(
                    option: opt,
                    from: \.dislikedGenres,
                    removingFrom: \.likedGenres
                )
            }
        }
    }
    
    func toggleGenre(
        option: BookGenre,
        from selectedKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>,
        removingFrom conflictKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>
    ) {
        // 충돌 제거: 반대 목록에서 제거
        localPrefs[keyPath: conflictKeyPath].removeAll { $0 == option }

        // 선택 목록에 토글 적용
        toggleOption(option, &localPrefs[keyPath: selectedKeyPath])

        // 유효성 검사
        localPrefs.validate()
    }
    
    
    
    
    
    /// 모든 PrefsOption 공통 토글 로직
    func toggleOption<Option: PrefsOption & Hashable>(
        _ option: Option,
        _ list: inout [Option]
    ) {
        let allCase = Option.allCases.first(where: { $0 == .all })!
        let individualOptions = Option.allCases.filter { $0 != .all }

        switch option {
        case allCase:
            // '모두'를 선택하면 다른 모든 옵션 제거하고 '모두'만
            list = [allCase]
            
        default:
            if list.contains(option) {
                // 이미 포함된 항목 → 제거
                list.removeAll { $0 == option }
                if list.isEmpty {
                    list = [allCase] // 아무것도 없으면 다시 '모두'
                }
            } else {
                // 새 항목 추가 → '모두' 제거 후 추가
                list.removeAll { $0 == allCase }
                list.append(option)
            }

            // 모든 개별 옵션이 선택되었는지 확인 → 자동으로 '모두'로 전환
            if Set(list) == Set(individualOptions) {
                list = [allCase]
            }
        }
    }
}

//#Preview {
//    CustomPrefsAlert(type: .ageGroup, bottomSheetPosition: <#Binding<BottomSheetPosition>#>)
//}

