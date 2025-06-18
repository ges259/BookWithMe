//
//  AladinAPI.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - AladinAPI
/// Aladin 오픈 API를 통해 책 데이터를 검색하고 베스트셀러 목록을 가져오는 유틸리티
enum AladinAPI {
    // 공개 프로퍼티
    static let apiKey = Constants.apiKey
    static let headers = ["User-Agent": Constants.userAgent]
    
    /// 제목 기반 책 검색 (페이징 및 반환 개수 조절 지원)
    ///
    /// - Parameters:
    ///   - query: 검색할 키워드
    ///   - page: 1부터 시작하는 페이지 번호 (기본 1)
    ///   - wantCount: 한 페이지당 클라이언트에 반환할 최대 책 개수 (기본 Constants.maxTitleResults = 7)
    /// - Returns: Book 모델 배열
    static func searchBooks(
        query: String,
        page: Int = 1,
        wantCount: Int = Constants.maxTitleResults
    ) async -> [Book] {
        // 요청할 최대 개수를 wantCount로 설정
        let maxResults = wantCount
        // API가 1부터 시작하는 Start 파라미터 사용: 첫 페이지 -> 1, 두 번째 -> maxResults+1
        let startIndex = (page - 1) * maxResults + 1

        // 동적 페이징 및 개수 반영 URL 생성
        guard let url = makeTitleSearchURL(
            for: query,
            maxResults: maxResults,
            startIndex: startIndex
        ) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(AladinItemResponse.self, from: data)
            // DTO -> Book 모델 변환
            return response.item
                .compactMap { Book(dto: $0) }
        } catch {
            // 네트워크 또는 디코딩 오류 시 빈 배열 반환
            return []
        }
    }
    
    /// 제목 검색용 URL 생성 (MaxResults, Start 지원)
    private static func makeTitleSearchURL(
        for title: String,
        maxResults: Int,
        startIndex: Int
    ) -> URL? {
        var comps = URLComponents(string: Constants.baseSearchURL)
        comps?.queryItems = [
            .init(name: "ttbkey",       value: apiKey),
            .init(name: "Query",        value: title),
            .init(name: "QueryType",    value: Constants.queryTypeKeyword),
            .init(name: "SearchTarget", value: Constants.searchTarget),
            .init(name: "output",       value: Constants.outputFormat),
            .init(name: "Version",      value: Constants.apiVersion),
            .init(name: "Cover",        value: Constants.coverSize),
            .init(name: "MaxResults",   value: "\(maxResults)"),
            .init(name: "Start",        value: "\(startIndex)")
        ]
        return comps?.url
    }
}
