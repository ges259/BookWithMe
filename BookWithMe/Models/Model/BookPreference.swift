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
struct BookPrefs: Codable {
    var language: [LanguageOption]
    var pageLength: [PageLength]
    var ageGroup: [AgeGroup]
    var readingPurpose: [ReadingPurpose]
    var likedGenres: [BookGenre]
    var dislikedGenres: [BookGenre]
    
    init(
        language: [LanguageOption] = [.all],
        pageLength: [PageLength]   = [.all],
        ageGroup: [AgeGroup]       = [.all],
        readingPurpose: [ReadingPurpose] = [.all],
        likedGenres: [BookGenre] = [.all],
        dislikedGenres: [BookGenre] = [.all]
    ) {
        self.language = language
        self.pageLength = pageLength
        self.ageGroup = ageGroup
        self.readingPurpose = readingPurpose
        self.likedGenres = likedGenres
        self.dislikedGenres = dislikedGenres
    }
    
    /// 샘플용 더미 데이터
    static let EMPTYDUMMY = BookPrefs()
    
    /// 같은 장르가 둘 다에 들어가지 않도록 헬퍼
    mutating func validate() {
        dislikedGenres.removeAll { likedGenres.contains($0) }
    }
}
