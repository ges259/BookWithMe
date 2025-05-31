//
//  BookAPIManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/17/25.
//


import Foundation
import NaturalLanguage
enum Secret {
//    static var apiKey: String {
//        Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
//    }
    static var apiKey: String = "Test8"
}

/*
 도서만 검색
 제목으로 검색
 페이지당 20개 가져오기
 
 
 책 이미지
 저자
 목차
 책 소개(description)
 */

// MARK: - BOOK API MANAGER
final class BookAPIManager {
    private struct Constants {
        static let baseURL = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
        static let apiKey  = Secret.apiKey
        static let maxResults = "20"
        struct Key {
            static let ttbKey = "ttbkey"
            static let query  = "Query"
            static let queryType = "QueryType"
            static let searchTarget = "SearchTarget"
            static let output = "Output"
            static let cover  = "Cover"
            static let start  = "start"
            static let maxResults = "MaxResults"
        }
        struct Value {
            static let queryType = "Title"
            static let searchTarget = "Book"
            static let outputFormat = "JS"        // JSON
            static let coverSize = "Big"
        }
    }
    
    static let shared = BookAPIManager(); private init() { }
    
    /// 제목 검색 → `Book` 배열(태그 포함) 반환
    func fetchBooks(
        byTitle title: String,
        page: Int = 1
    ) async throws -> [Book] {
        let url = try makeSearchURL(title: title, page: page)
        let (raw, _) = try await URLSession.shared.data(from: url)
        // 알라딘 JSON 맨 끝에 `;` 문자 제거
        let data = (raw.last == 0x3B) ? Data(raw.dropLast()) : raw
        let dtoModels = try JSONDecoder()
            .decode(AladinSearchResponse.self, from: data)
            .items
        return dtoModels.compactMap { Book(dto: $0) }
    }
    
    // MARK: URL 조립
    private func makeSearchURL(title: String, page: Int) throws -> URL {
        var comps = URLComponents(string: Constants.baseURL)
        comps?.queryItems = [
            .init(name: Constants.Key.ttbKey, 
                  value: Constants.apiKey),
            .init(name: Constants.Key.query , 
                  value: title),
            .init(name: Constants.Key.queryType , 
                  value: Constants.Value.queryType),
            .init(name: Constants.Key.searchTarget , 
                  value: Constants.Value.searchTarget),
            .init(name: Constants.Key.output , 
                  value: Constants.Value.outputFormat),
            .init(name: Constants.Key.cover , 
                  value: Constants.Value.coverSize),
            .init(name: Constants.Key.start , 
                  value: "\(page)"),
            .init(name: Constants.Key.maxResults , 
                  value: Constants.maxResults)
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        return url
    }
}










// MARK: - TAG GENERATOR
enum TagGenerator {
    static func generateTags(from dto: AladinBookDTO) -> [String] {
        var tags = [String]()
        
        // 1) 카테고리(마지막 뎁스)
        if let cat = dto.categoryName?.components(separatedBy: ">").last {
            tags.append(cat)
        }
        // 2) 작가 · 출판사
        tags.append(dto.author)
        tags.append(dto.publisher)
        
        // 3) 연도
        if let year = dto.pubDate?.prefix(4) {
            tags.append("\(year)년")
        }
        // 4) 분량
        if let pages = dto.itemPage {
            switch pages {
            case 0..<200: tags.append("단편")
            case 200..<400: tags.append("중편")
            default: tags.append("장편")
            }
        }
        // 5) NLP 키워드(설명+목차)
        let text = [dto.description, dto.toc]
            .compactMap { $0 }
            .joined(separator: " ")
        tags.append(contentsOf: topKeywords(in: text, max: 5))
        
        return Array(Set(tags))             // 중복 제거
    }
    
    /// NaturalLanguage 기반 명사 키워드 추출
    private static func topKeywords(in text: String, max: Int) -> [String] {
        guard !text.isEmpty else { return [] }
        let tagger = NLTagger(tagSchemes: [.lexicalClass])
        tagger.string = text
        
        var counts = [String: Int]()
        let options: NLTagger.Options = [.omitPunctuation, .omitWhitespace, .joinNames]
        
        tagger.enumerateTags(in: text.startIndex..<text.endIndex,
                             unit: .word,
                             scheme: .lexicalClass,
                             options: options) { tag, range in
            if tag == .noun {
                let word = String(text[range])
                counts[word, default: 0] += 1
            }
            return true
        }
        // 빈도순 상위 max개 반환
        return counts.sorted { $0.value > $1.value }.prefix(max).map { $0.key }
    }
}

// MARK: - DTO (원본 그대로 두고 필드만 보강)
struct AladinBookDTO: Decodable {
    let title: String
    let author: String
    let publisher: String
    let description: String?
    let toc: String?
    let cover: String?
    let itemId: Int
    let isbn13: String?
    let categoryName: String?
    let pubDate: String?          // "2024-03-15"
    let itemPage: Int?            // 페이지 수
    
    enum CodingKeys: String, CodingKey {
        case title, author, publisher, description, toc, cover, itemId, isbn13
        case categoryName, pubDate, itemPage
    }
}

// MARK: - SEARCH RESPONSE
private struct AladinSearchResponse: Decodable {
    let items: [AladinBookDTO]
    enum CodingKeys: String, CodingKey { case items = "item" }
}
