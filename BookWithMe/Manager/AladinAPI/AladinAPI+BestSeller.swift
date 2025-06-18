//
//  AladinAPI+BestSeller.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import Foundation

// MARK: - 베스트셀러
extension AladinAPI {
    /// 장르별 베스트셀러 책 조회
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
    
    /// 장르별 조회용 URL 생성
    private static func makeGenreURL(for genre: String) -> URL? {
        let genreCode = AladinGenres[genre] ?? "1"
        var comps = URLComponents(string: Constants.baseGenreURL)
        comps?.queryItems = [
            URLQueryItem(name: "ttbkey",       value: apiKey),
            URLQueryItem(name: "QueryType",    value: Constants.queryTypeBestseller),
            URLQueryItem(name: "CategoryId",   value: genreCode),
            URLQueryItem(name: "SearchTarget", value: Constants.searchTarget),
            URLQueryItem(name: "output",       value: Constants.outputFormat),
            URLQueryItem(name: "Version",      value: Constants.apiVersion),
            URLQueryItem(name: "Cover",        value: Constants.coverSize),
            URLQueryItem(name: "MaxResults",   value: "\(Constants.maxGenreResults)")
        ]
        return comps?.url
    }
    
    /// 지원 장르와 API 카테고리 ID 매핑
    private static let AladinGenres: [String: String] = [
        "문학": "1",
        "로맨스": "336",
        "추리/스릴러": "798",
        "판타지": "2913",
        "SF(공상과학)": "8257",
        "역사": "74",
        "자기계발": "336",
        "에세이": "55889"
    ]
}

extension AladinAPI {
    /// 전체 베스트셀러를 가져옵니다 (기본 장르 없이)
    static func fetchBestSellers(count: Int = Constants.maxGenreResults) async -> [Book] {
        
        guard let url = makeBestSellerURL() else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let items = try JSONDecoder()
                .decode(AladinItemResponse.self, from: data)
                .item
            return items
                .compactMap { Book(dto: $0) }
                .prefix(count)
                .map { $0 }
        } catch {
            print("❌ 베스트셀러 조회 실패:", error)
            return []
        }
    }

    /// 전체 베스트셀러용 URL 생성
    private static func makeBestSellerURL() -> URL? {
        var comps = URLComponents(string: Constants.baseGenreURL)
        comps?.queryItems = [
            URLQueryItem(name: "ttbkey",       value: apiKey),
            URLQueryItem(name: "QueryType",    value: Constants.queryTypeBestseller),
            URLQueryItem(name: "SearchTarget", value: Constants.searchTarget),
            URLQueryItem(name: "output",       value: Constants.outputFormat),
            URLQueryItem(name: "Version",      value: Constants.apiVersion),
            URLQueryItem(name: "Cover",        value: Constants.coverSize),
            URLQueryItem(name: "MaxResults",   value: "\(Constants.maxGenreResults)")
        ]
        return comps?.url
    }
}
