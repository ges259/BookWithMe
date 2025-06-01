//
//  PrefsOptionType.swift
//  BookWithMe
//
//  Created by 계은성 on 6/1/25.
//

import Foundation

// MARK: - PrefsOption
protocol PrefsOption: CaseIterable, Identifiable, RawRepresentable, Codable, Hashable where RawValue == String {
    static var title: String { get }
    static var all: Self { get } // 이 줄 추가
    var label: String { get }
}

extension PrefsOption {
    var id: String { self.rawValue }
    
    var label: String {
        return self.rawValue
    }
}

// MARK: - Enum
enum LanguageOption: String, PrefsOption {
    case all = "모두"
    case koreanOnly = "한국 도서만"
    case includeForeign = "외국 도서 포함"
    
    static var title: String { "언어" }
}

enum PageLength: String, PrefsOption {
    case all = "모두"
    case short = "단편 (~200)"
    case medium = "중편 (200~400)"
    case long = "장편 (400~)"
    
    static var title: String { "분량" }
}

enum AgeGroup: String, PrefsOption {
    case all = "모두"
    case teen = "10대"
    case twenty = "20대"
    case thirty = "30대"
    case fortyPlus = "40대 이상"
    
    static var title: String { "연령대" }
}

enum ReadingPurpose: String, PrefsOption {
    
    case all = "모두"
    case healing = "힐링/위로"
    case selfHelp = "자기계발"
    case study = "공부"
    case light = "가볍게"
    case immersive = "몰입감"
    
    static var title: String { "읽는 목적" }
}

// MARK: - 공통 장르 Enum
enum BookGenre: String, PrefsOption, Codable {
    /// enum case
    case all             = "모두"
    case literature      = "문학"
    case romance         = "로맨스"
    case mystery         = "추리/스릴러"
    case fantasy         = "판타지"
    case scienceFiction  = "SF(공상과학)"
    case history         = "역사"
    case selfHelp        = "자기계발"
    case essay           = "에세이"
    case humanities      = "인문학"
    case societyPolitics = "사회/정치"
    case economics       = "경제/경영"
    case science         = "과학"
    case artDesign       = "예술/디자인"
    case religion        = "종교/철학"
    case parenting       = "육아/가정"
    case health          = "건강/의학"
    case travel          = "여행"
    case cooking         = "요리"
    case comics          = "만화/그래픽노블"
    case youngAdult      = "청소년"
    case children        = "어린이"
    
    // PrefsOption 요구 사항
    static var title: String { "장르" }
}





// MARK: - CustomPrefsType
enum CustomPrefsType: String, CaseIterable, Identifiable, Codable {
    case language
    case pageLength
    case ageGroup
    case readingPurpose
    case likedGenres
    case dislikedGenres
    
    var id: String { self.rawValue }
    
    
    var isFirstCell: Bool {
        return self == .language
    }
    
    var isHStackScroll: Bool {
        switch self {
        case .likedGenres, .dislikedGenres:
            return true
        default:
            return false
        }
    }
    
    var title: String {
        switch self {
        case .language:
            return LanguageOption.title
        case .pageLength:
            return PageLength.title
        case .ageGroup:
            return AgeGroup.title
        case .readingPurpose:
            return ReadingPurpose.title
        case .likedGenres:
            return "선호 장르"
        case .dislikedGenres:
            return "비선호 장르"
        }
    }
    
    var options: [any PrefsOption.Type]? {
        switch self {
        case .language: return [LanguageOption.self]
        case .pageLength: return [PageLength.self]
        case .ageGroup: return [AgeGroup.self]
        case .readingPurpose: return [ReadingPurpose.self]
        case .likedGenres, .dislikedGenres: return nil
        }
    }
}
