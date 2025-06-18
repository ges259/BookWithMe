//
//  AladinAPI.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - AladinAPI
enum AladinAPI {
    static let apiKey = APIKey.aladin_Key
    static let headers = ["User-Agent": "Mozilla/5.0"]

    static func searchBooks(query: String, wantCount: Int = 10) async -> [Book] {
         guard let url = makeTitleSearchURL(for: query) else { return [] }

         do {
             let (data, _) = try await URLSession.shared.data(from: url)
             let response = try JSONDecoder().decode(AladinItemResponse.self, from: data)
             return response.item
                 .compactMap { Book(dto: $0) }
                 .prefix(wantCount)
                 .map { $0 }
         } catch {
             return []
         }
     }

    static func fetchGenreBooks(_ count: Int, genre: String, excludeIds: Set<String>) async -> [Book] {
        guard let url = makeGenreURL(for: genre) else { return [] }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let items = try JSONDecoder().decode(AladinItemResponse.self, from: data).item

            return items
                .filter { !excludeIds.contains($0.isbn13 ?? "") }
                .compactMap { Book(dto: $0) }
                .prefix(count)
                .map { $0 }
        } catch {
            return []
        }
    }

    private static func makeTitleSearchURL(for title: String) -> URL? {
        var comps = URLComponents(string: "http://www.aladin.co.kr/ttb/api/ItemSearch.aspx")
        comps?.queryItems = [
            URLQueryItem(name: "ttbkey", value: apiKey),
            URLQueryItem(name: "Query", value: title),
            URLQueryItem(name: "QueryType", value: "Keyword"),  // ✅ 부분 검색으로 변경
            URLQueryItem(name: "SearchTarget", value: "Book"),
            URLQueryItem(name: "output", value: "js"),
            URLQueryItem(name: "Version", value: "20131101"),
            URLQueryItem(name: "Cover", value: "Big"),
            URLQueryItem(name: "MaxResults", value: "10")  // ← 결과 여러 개 가능
        ]
        return comps?.url
    }

    private static func makeGenreURL(for genre: String) -> URL? {
        let genreCode = AladinGenres[genre] ?? "1"
        var comps = URLComponents(string: "http://www.aladin.co.kr/ttb/api/ItemList.aspx")
        comps?.queryItems = [
            URLQueryItem(name: "ttbkey", value: apiKey),
            URLQueryItem(name: "QueryType", value: "Bestseller"),
            URLQueryItem(name: "CategoryId", value: genreCode),
            URLQueryItem(name: "SearchTarget", value: "Book"),
            URLQueryItem(name: "output", value: "js"),
            URLQueryItem(name: "Version", value: "20131101"),
            URLQueryItem(name: "Cover", value: "Big"),
            URLQueryItem(name: "MaxResults", value: "20")
        ]
        return comps?.url
    }

    private static let AladinGenres: [String: String] = [
        "문학": "1", "로맨스": "336", "추리/스릴러": "798", "판타지": "2913",
        "SF(공상과학)": "8257", "역사": "74", "자기계발": "336", "에세이": "55889"
    ]
}
