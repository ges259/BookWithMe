//
//  CustomPrefsAlertViewModel.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import Foundation

import SwiftUI

/// UI에 독립적인 비즈니스 로직을 담당하는 뷰 모델입니다.
/// `@Observable` 매크로를 사용하여 이 클래스의 속성 변경이 SwiftUI 뷰에 자동으로 전파되도록 합니다.
@Observable
final class CustomPrefsAlertViewModel {
    /// 이 뷰 모델이 관리할 설정(prefs)의 타입을 나타냅니다 (예: 언어, 페이지 길이, 장르 등).
    let type: CustomPrefsType
    
    /// 상위 뷰(Parent View)로부터 전달받은 `BookPrefs`에 대한 `Binding`을 저장합니다.
    /// `BookPrefs`가 `struct`(값 타입)이므로, 원본 데이터를 수정하기 위해 `Binding`이 필요합니다.
    private var prefsBinding: Binding<BookPrefs>

    /// `BookPrefs` 값에 대한 계산 속성입니다.
    /// 이 속성을 통해 뷰 모델 내부에서 `BookPrefs`의 실제 값에 접근하거나 변경할 수 있습니다.
    /// `get` 시에는 `prefsBinding`의 `wrappedValue`를 반환하고,
    /// `set` 시에는 `prefsBinding`의 `wrappedValue`를 새로운 값으로 업데이트하여
    /// 상위 뷰의 원본 `@State` 변수를 변경하고 UI 업데이트를 트리거합니다.
    var prefs: BookPrefs {
        get { prefsBinding.wrappedValue }
        set {
            // prefs 값이 변경되기 직전의 로그 (디버깅용)
            // 예를 들어, newValue.pageLength를 통해 변경될 페이지 길이를 확인할 수 있습니다.
            // print("prefs will set: \(newValue.pageLength)")
            
            // `Binding`의 `wrappedValue`를 업데이트하여 상위 뷰의 원본 데이터를 변경합니다.
            prefsBinding.wrappedValue = newValue
            
            // prefs 값이 변경된 직후의 로그 (디버깅용)
            // print("prefs did set: \(prefsBinding.wrappedValue.pageLength)")
        }
    }

    /// `CustomPrefsAlertViewModel`을 초기화합니다.
    /// - Parameters:
    ///   - type: 관리할 설정의 종류를 나타내는 `CustomPrefsType` 값입니다.
    ///   - prefs: 상위 뷰의 `BookPrefs` `@State` 변수에 대한 `Binding`입니다.
    ///            상위 뷰에서는 `$myBookPrefs`와 같이 `$`를 붙여서 전달해야 합니다.
    init(
        type: CustomPrefsType,
        prefs: Binding<BookPrefs>
    ) {
        self.type = type
        self.prefsBinding = prefs // 전달받은 Binding을 저장합니다.
    }
    
    /// 설정 변경 사항을 영구적으로 저장하는 메서드입니다.
    /// 일반적으로 뷰가 사라질 때(`onDisappear`) 호출하여 사용자가 선택한 내용을 저장합니다.
    func save() {
        // `prefs` 계산 속성을 통해 현재의 `BookPrefs` 값을 가져와 BookCache에 저장합니다.
        BookCache.shared.saveBookPrefs(prefs)
    }
    
    
    // MARK: - Public API (외부에서 호출 가능한 메서드)
    /// 주어진 옵션(예: 언어, 페이지 길이)의 선택 상태를 토글합니다.
    /// 이 메서드는 `CustomPrefsAlert` 뷰의 각 옵션 버튼에서 호출됩니다.
    /// - Parameter option: 토글할 `PrefsOption`을 준수하는 특정 옵션 값입니다.
    func toggle<Option: PrefsOption>(_ option: Option) {
        // `type`에 따라 적절한 설정 목록을 찾아 토글 로직을 적용합니다.
        switch type {
        case .language:
            // 전달된 `option`이 `LanguageOption` 타입인지 확인합니다.
            guard let opt = option as? LanguageOption else { return }
            // `prefs.language` 배열의 선택 상태를 토글합니다.
            // `&prefs.language`는 `prefs` 내부 `language` 배열에 대한 Inout(참조)을 전달합니다.
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
            // '좋아하는 장르' 토글 시, '싫어하는 장르' 목록에서 해당 장르를 제거합니다.
            toggleGenre(
                option: opt,
                from: \.likedGenres,       // 토글할 목록
                removingFrom: \.dislikedGenres // 충돌 시 제거할 목록
            )

        case .dislikedGenres:
            guard let opt = option as? BookGenre else { return }
            // '싫어하는 장르' 토글 시, '좋아하는 장르' 목록에서 해당 장르를 제거합니다.
            toggleGenre(
                option: opt,
                from: \.dislikedGenres,
                removingFrom: \.likedGenres
            )
        }
    }

}

private extension CustomPrefsAlertViewModel {

    /// 특정 장르 옵션을 토글하면서, 다른 충돌하는 장르 목록에서 해당 옵션을 제거합니다.
    /// 예를 들어, "판타지"를 좋아하는 장르로 선택하면, 싫어하는 장르 목록에서는 "판타지"가 제거됩니다.
    /// - Parameters:
    ///   - option: 토글할 `BookGenre` 옵션
    ///   - selectedKeyPath: 토글할 대상 장르 목록의 `WritableKeyPath` (예: `\.likedGenres`).
    ///   - conflictKeyPath: 충돌 시 해당 `option`을 제거할 장르 목록의 `WritableKeyPath` (예: `\.dislikedGenres`).
    func toggleGenre(
        option: BookGenre,
        from selectedKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>,
        removingFrom conflictKeyPath: WritableKeyPath<BookPrefs, [BookGenre]>
    ) {
        // 충돌하는 목록(conflictKeyPath)에서 현재 옵션을 제거합니다.
        // `prefs[keyPath: ...]` 문법을 사용하여 `BookPrefs`의 특정 배열에 접근합니다.
        prefs[keyPath: conflictKeyPath].removeAll { $0 == option }
        
        // 대상 목록(selectedKeyPath)에서 실제 토글 로직을 수행합니다.
        toggleOption(option, &prefs[keyPath: selectedKeyPath])
        
        // 장르 목록의 유효성(겹침 방지, 비어있을 경우 '.all' 처리 등)을 검사합니다.
        validate()
    }

    /// '좋아하는 장르'와 '싫어하는 장르' 목록의 유효성을 검사하고,
    /// 서로 겹치는 장르가 없도록 정리하며, 목록이 비어있을 경우 `.all`로 설정합니다.
    func validate() {
        // '전체' 옵션을 제외한 '좋아하는 장르'와 '싫어하는 장르' 세트를 생성합니다.
        let liked     = Set(prefs.likedGenres).subtracting([.all])
        let disliked  = Set(prefs.dislikedGenres).subtracting([.all])
        
        // 겹치는 장르를 찾습니다.
        let overlap   = liked.intersection(disliked)

        // 겹치는 장르가 있다면 양쪽 목록에서 제거합니다.
        prefs.likedGenres    .removeAll { overlap.contains($0) }
        prefs.dislikedGenres .removeAll { overlap.contains($0) }

        // 만약 목록이 비어있다면, 기본값인 `.all`로 설정합니다.
        if prefs.likedGenres.isEmpty    { prefs.likedGenres    = [.all] }
        if prefs.dislikedGenres.isEmpty { prefs.dislikedGenres = [.all] }
    }

    /// 단일 또는 다중 선택 옵션의 선택 상태를 토글하는 일반화된 로직입니다.
    /// '모두' 옵션과 개별 옵션 간의 상호작용을 처리합니다.
    /// - Parameters:
    ///   - option: 토글할 `PrefsOption` 타입의 옵션입니다.
    ///   - list: 현재 선택된 옵션들을 담고 있는 배열에 대한 `inout` 참조입니다.
    ///           이 참조를 통해 원본 배열의 내용을 직접 수정할 수 있습니다.
    func toggleOption<Option: PrefsOption & Hashable>(
        _ option: Option,
        _ list: inout [Option] // `inout` 키워드로 전달된 원본 배열을 직접 수정할 수 있습니다.
    ) {
        // 모든 옵션 중 '모두'에 해당하는 케이스를 찾습니다. (`PrefsOption`은 `.all`을 가지고 있어야 합니다.)
        let allCase           = Option.allCases.first { $0 == .all }!
        // '모두' 옵션을 제외한 개별 옵션들을 필터링합니다.
        let individualOptions = Option.allCases.filter { $0 != .all }

        switch option {
        case allCase:
            // 사용자가 '모두' 옵션을 선택하면, 목록을 오직 '모두'로 설정합니다.
            list = [allCase]

        default:
            // 사용자가 개별 옵션을 선택한 경우:
            if list.contains(option) {
                // 이미 선택된 옵션이라면, 목록에서 해당 옵션을 제거(해제)합니다.
                list.removeAll { $0 == option }
                // 옵션을 모두 해제하여 목록이 비게 되면, 자동으로 '모두' 옵션을 선택합니다.
                if list.isEmpty { list = [allCase] }
            } else {
                // 선택되지 않은 옵션이라면,
                // 먼저 '모두' 옵션이 있다면 제거하고,
                list.removeAll { $0 == allCase }
                // 현재 옵션을 목록에 추가합니다.
                list.append(option)
            }
            
            // 만약 현재 선택된 개별 옵션들의 집합이 모든 개별 옵션들의 집합과 같다면,
            // (즉, 모든 개별 옵션이 선택되었다면) 목록을 '모두' 옵션 하나로 정리합니다.
            if Set(list) == Set(individualOptions) {
                list = [allCase]
            }
        }
    }
}
