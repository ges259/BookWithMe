//
//  AladinAPI+BestSeller.swift
//  BookWithMe
//
//  Created by 계은성 on 6/19/25.
//

import Foundation

// MARK: - 베스트셀러
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
