//
//  BookPreference.swift
//  BookWithMe
//
//  Created by 계은성 on 5/31/25.
//

import Foundation

/*
  -------------------------
  - 추천 화면
  언어 (한국 도서만 / 외국 도서 포함)
  책 분량 선호 ( ~200 / 200 ~ 400 / 400~)
  연령대 (10 / 20 / 30 / 40~ )
  선호 장르, 비선호 장르 (좋아요 / 싫어요)
  읽기 목적 (힐링+위로 / 자기계발 / 공부 / 가볍게 / 몰입감)

  -------------------------
  - 컨텐츠 기반 추천
  사용자가 몇 권의 책을 고르고그 책들의 분류 / 키워드 / 작가 / 톤을 기반으로 유사한 책 추천
 api를 통해 가져온 데이터 활용( 카테고리 + 저자 + 출판사 + 연도 + 분량 + 핵심 키워드)

  -------------------------
 */


// MARK: - Model
struct BookPrefs {
    var language: LanguageOption
    var pageLength: PageLength
    var ageGroup: AgeGroup
    var readingPurpose: ReadingPurpose
    var likedGenres: [String]
    var dislikedGenres: [String]
    
    init(language: LanguageOption, pageLength: PageLength, ageGroup: AgeGroup, readingPurpose: ReadingPurpose, likedGenres: [String], dislikedGenres: [String]) {
        
        self.language = language
        self.pageLength = pageLength
        self.ageGroup = ageGroup
        self.readingPurpose = readingPurpose
        self.likedGenres = likedGenres
        self.dislikedGenres = dislikedGenres
    }
    
    /// 샘플용 더미 데이터
     static var EMPTYDUMMY: BookPrefs {
         .init(
            language: .all,             // 외국 도서 포함
            pageLength: .all,                   // 중편 (200~400쪽)
            ageGroup: .all,                     // 20대
            readingPurpose: .all,              // 힐링/위로
            likedGenres: [],     // 선호 장르
            dislikedGenres: []       // 비선호 장르
         )
     }
}




// MARK: - PrefsOption
protocol PrefsOption: CaseIterable, Identifiable, RawRepresentable, Codable where RawValue == String {
    static var title: String { get }
    var label: String { get }
}

extension PrefsOption {
    var id: String { self.rawValue }
}

// MARK: - Enum
enum LanguageOption: String, PrefsOption {
    case all = "모두"
    case koreanOnly = "한국 도서만"
    case includeForeign = "외국 도서 포함"

    static var title: String { "언어" }

    var label: String {
        switch self {
        case .all: return "모두"
        case .koreanOnly: return "한국 도서만"
        case .includeForeign: return "외국 도서 포함"
        }
    }
}

enum PageLength: String, PrefsOption {
    case all = "모두"
    case short = "단편 (~200)"
    case medium = "중편 (200~400)"
    case long = "장편 (400~)"

    static var title: String { "분량" }

    var label: String {
        switch self {
        case .all: return "모두"
        case .short: return "~200"
        case .medium: return "200~400"
        case .long: return "400~"
        }
    }
}

enum AgeGroup: String, PrefsOption {
    case all = "모두"
    case teen = "10대"
    case twenty = "20대"
    case thirty = "30대"
    case fortyPlus = "40대 이상"

    static var title: String { "연령대" }

    var label: String {
        return self.rawValue
    }
}

enum ReadingPurpose: String, PrefsOption {
    
    case all = "모두"
    case healing = "힐링/위로"
    case selfHelp = "자기계발"
    case study = "공부"
    case light = "가볍게"
    case immersive = "몰입감"

    static var title: String { "읽는 목적" }

    var label: String {
        return self.rawValue
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
        return self == .language || self == .dislikedGenres
    }
    var isLastCell: Bool {
        return self == .likedGenres || self == .dislikedGenres
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
