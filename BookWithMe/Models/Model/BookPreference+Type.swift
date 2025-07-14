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
    var label: String { self.rawValue }
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
    
    var categoryID: String {
        switch self {
        case .literature:       return "1"
        case .health:           return "55890"
        case .economics:        return "170"
        case .history:          return "74"
        case .essay:            return "55889"
        case .travel:           return "1196"
        case .science:          return "987"
        case .artDesign:        return "517"
        case .religion:         return "1237"
        case .selfHelp:         return "336"
        case .cooking:          return "1230"
        case .comics:           return "2551"
        case .humanities:       return "656"
        case .parenting:        return "2030"
        case .youngAdult:       return "1137"
        case .children:         return "1108"
        case .societyPolitics:  return "798"
        // 매핑되지 않은 항목
        default:                return "1"
        }
    }
}
// 삭제하거나 아래처럼 바꿀 수 있음
extension BookGenre {
    var aladinCategoryID: String {
        return self.categoryID
    }
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
    
    
    // "all"을 제외한 필터링을 처리
       func filterGenres(genres: [BookGenre]) -> [BookGenre] {
           // "all"을 제외하고 필터링
           return genres.filter { $0 != .all }
       }
}
