//
//  AladinAPI+Constants.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import Foundation

// MARK: - Constants
extension AladinAPI {
    /// 하드코딩된 상수들을 모아두는 네스트된 타입
    enum Constants {
        // Aladin API 키
        static let apiKey               = APIKey.aladin_Key
        // HTTP 요청 헤더 User-Agent
        static let userAgent            = "Mozilla/5.0"
        // 제목 검색 엔드포인트
        static let baseSearchURL        = "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
        // 장르별 조회 엔드포인트
        static let baseGenreURL         = "http://www.aladin.co.kr/ttb/api/ItemList.aspx"
        // 제목 검색 타입: 부분 검색
        static let queryTypeKeyword     = "Keyword"
        // 장르별 조회 타입: 베스트셀러
        static let queryTypeBestseller  = "Bestseller"
        // 검색 대상: 도서
        static let searchTarget         = "Book"
        // 응답 포맷: JSON
        static let outputFormat         = "js"
        // API 버전
        static let apiVersion           = "20131101"
        // 이미지 커버 크기
        static let coverSize            = "Big"
        // 제목 검색 시 최대 요청 개수
        static let maxTitleResults      = 7
        // 장르별 조회 시 최대 요청 개수
        static let maxGenreResults      = 20
    }
}
