//
//  CustomPrefsAlertViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import Foundation

import SwiftUI
import BottomSheet
import Observation

/// UI-독립 비즈니스 로직
@Observable
final class CustomPrefsAlertViewModel {
    let type: CustomPrefsType
    var prefs: BookPrefs

    // MARK: - Init
    init(
        type: CustomPrefsType,
        prefs: Binding<BookPrefs>
    ) {
        self.type                = type
        self.prefs               = prefs.wrappedValue
    }
    
    
    
    /// onDisappear 등에서 호출
    func save() {
        BookCache.shared.saveBookPrefs(prefs)
    }
    
    
    
    // MARK: - Public API
    func toggle<Option: PrefsOption>(_ option: Option) {
        switch type {
        case .language:
            guard let opt = option as? LanguageOption else { return }
            toggleOption(opt, &prefs.language)

        case .pageLength:
            guard let opt = option as? PageLength else { return }
            toggleOption(opt, &prefs.pageLength)

        case .ageGroup:
            guard let opt = option as? AgeGroup else { return }
            toggleOption(opt, &prefs.ageGroup)

        case .readingPurpose:
            guard let opt = option as? ReadingPurpose else { return }
            toggleOption(opt, &prefs.readingPurpose)

        case .likedGenres:
            guard let opt = option as? BookGenre else { return }
            toggleGenre(
                option: opt,
                from: \.likedGenres,
                removingFrom: \.dislikedGenres
            )

        case .dislikedGenres:
            guard let opt = option as? BookGenre else { return }
            toggleGenre(
                option: opt,
                from: \.dislikedGenres,
                removingFrom: \.likedGenres
            )
        }
    }

}





// MARK: - Private 토글 로직
private extension CustomPrefsAlertViewModel {

    func toggleGenre(
        option: BookGenre,
        from selectedKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>,
        removingFrom conflictKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>
    ) {
        // 충돌 제거
        prefs[keyPath: conflictKeyPath].removeAll { $0 == option }
        // 실제 토글
        toggleOption(option, &prefs[keyPath: selectedKeyPath])
        validate()
    }

    func validate() {
        let liked     = Set(prefs.likedGenres).subtracting([.all])
        let disliked  = Set(prefs.dislikedGenres).subtracting([.all])
        let overlap   = liked.intersection(disliked)

        prefs.likedGenres    .removeAll { overlap.contains($0) }
        prefs.dislikedGenres .removeAll { overlap.contains($0) }

        if prefs.likedGenres.isEmpty    { prefs.likedGenres    = [.all] }
        if prefs.dislikedGenres.isEmpty { prefs.dislikedGenres = [.all] }
    }

    func toggleOption<Option: PrefsOption & Hashable>(
        _ option: Option,
        _ list: inout [Option]
    ) {
        let allCase           = Option.allCases.first { $0 == .all }!
        let individualOptions = Option.allCases.filter { $0 != .all }

        switch option {
        case allCase:
            list = [allCase]                      // ‘모두’

        default:
            if list.contains(option) {
                list.removeAll { $0 == option }   // 해제
                if list.isEmpty { list = [allCase] }
            } else {
                list.removeAll { $0 == allCase }  // ‘모두’ 제거
                list.append(option)               // 추가
            }
            if Set(list) == Set(individualOptions) {
                list = [allCase]                  // 전부 선택 → ‘모두’
            }
        }
    }
}
