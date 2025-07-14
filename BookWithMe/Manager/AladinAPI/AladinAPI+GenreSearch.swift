//
//  AladinAPI+GenreSearch.swift
//  BookWithMe
//
//  Created by 계은성 on 7/9/25.
//

import Foundation

extension AladinAPI {
    /// 장르별 책 조회
    ///
    /// - Parameters:
    ///   - count: 클라이언트에 반환할 최대 책 개수 (기본 Constants.maxGenreResults)
    ///   - genre: 조회할 장르 이름
    ///   - excludeIds: 제외할 ISBN 리스트
    /// - Returns: Book 모델 배열
    static func fetchGenreBooks(
        _ count: Int = Constants.maxGenreResults,
        genre: String,
        excludeIds: Set<String>
    ) async -> [Book] {
        // 장르별 조회 URL 생성
        guard let url = makeGenreURL(for: genre) else { return [] }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder()
                .decode(AladinItemResponse.self, from: data)
                .item

            // excludeIds에 포함된 ISBN은 제외하고 매핑, 갯수 제한 적용
            return items
                .filter { !excludeIds.contains($0.isbn13 ?? "") }
                .compactMap { Book(dto: $0) }
                .prefix(count)
                .map { $0 }
        } catch {
            return []
        }
    }
    
    /// 문자열을 BookGenre로 변환하고, 해당 장르의 Aladin 카테고리 ID로 URL 생성
    private static func makeGenreURL(for genre: String) -> URL? {
        // 1. 문자열을 BookGenre로 변환 (rawValue 기반)
        guard let genreEnum = BookGenre.allCases.first(where: { $0.rawValue == genre }) else {
            // 일치하는 장르가 없으면 기본값 사용
            return makeGenreURLWithCategoryID("1")
        }
        
        // 2. 해당 장르의 ID로 URL 생성
        return makeGenreURLWithCategoryID(genreEnum.aladinCategoryID)
    }

    /// 주어진 카테고리 ID로 Aladin 장르 URL 생성
    private static func makeGenreURLWithCategoryID(_ categoryID: String) -> URL? {
        var comps = URLComponents(string: Constants.baseGenreURL)
        comps?.queryItems = [
            URLQueryItem(name: "ttbkey",       value: apiKey),
            URLQueryItem(name: "QueryType",    value: Constants.queryTypeBestseller),
            URLQueryItem(name: "CategoryId",   value: categoryID),
            URLQueryItem(name: "SearchTarget", value: Constants.searchTarget),
            URLQueryItem(name: "output",       value: Constants.outputFormat),
            URLQueryItem(name: "Version",      value: Constants.apiVersion),
            URLQueryItem(name: "Cover",        value: Constants.coverSize),
            URLQueryItem(name: "MaxResults",   value: "\(Constants.maxGenreResults)")
        ]
        return comps?.url
    }
}
