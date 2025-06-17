//
//  BookAPIManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/17/25.
//


import Foundation
import NaturalLanguage

// MARK: - BACKEND BOOK MODEL
struct BackendBook: Decodable {
    let id: String
    let title: String
    let author: String
    let publisher: String?
    let description: String?
    let imageURL: String?
    let categoryName: String?
}

// MARK: - BOOK MODEL INIT EXTENSION
extension Book {
    /// BackendBook 으로부터 Book 생성 (Book struct init?(dto:) 대체)
    init?(backend: BackendBook) {
        // isbn(id)가 비어있으면 생성 실패
        let isbn = backend.id
        guard !isbn.isEmpty else { return nil }

        self.id = isbn
        self.title = backend.title
        self.author = backend.author
        self.publisher = backend.publisher
        self.description = backend.description ?? "설명 없음"
        self.imageURL = backend.imageURL
        self.keywords = TagGenerator.generateTags(from: backend)
        self.history = BookHistory(bookId: isbn)
    }
}

// MARK: - TAG GENERATOR (BackendBook 사용)
enum TagGenerator {
    static func generateTags(from book: BackendBook) -> [String] {
        var tags = [String]()
        
        // 1) 카테고리(끝부분)
        if let cat = book.categoryName?.components(separatedBy: ">").last {
            tags.append(cat)
        }
        
        // 2) 작가 · 출판사
        tags.append(book.author)
        if let pub = book.publisher {
            tags.append(pub)
        }
        
        // 3) NLP 키워드(description 기반)
        if let text = book.description, !text.isEmpty {
            tags.append(contentsOf: topKeywords(in: text, max: 5))
        }
        
        return Array(Set(tags))
    }

    private static func topKeywords(in text: String, max: Int) -> [String] {
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
        
        return counts.sorted { $0.value > $1.value }
                     .prefix(max)
                     .map { $0.key }
    }
}

// MARK: - BOOK API MANAGER (SEARCH)
final class BookAPIManager {
    private struct Constants {
        static let baseURL        = "http://192.168.45.251:5001"
        static let searchEndpoint = "/search"
        static let defaultCount   = 10
    }

    static let shared = BookAPIManager()
    private init() { }

    /// `/search?q=...` 요청 → BackendBook 배열 → Book 모델로 매핑
    func searchBooks(
        query: String,
        wantCount: Int = Constants.defaultCount
    ) async throws -> [Book] {
        // 1) URL 준비
        guard var comps = URLComponents(string: Constants.baseURL + Constants.searchEndpoint) else {
            throw URLError(.badURL)
        }
        comps.queryItems = [
            URLQueryItem(name: "q", value: query)
        ]
        guard let url = comps.url else {
            throw URLError(.badURL)
        }
        print("🔍 호출 URL:", url)   // ← 이 줄 추가
        
        // 2) URLRequest 생성 (메서드, 헤더 등 필요 시 추가)
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        // 3) 요청 보내고 응답까지 받기
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse else {
            print("🔴 searchBooks: 응답이 HTTPURLResponse 가 아닙니다.")
            throw URLError(.badServerResponse)
        }

        // 4) 상태 코드 확인
        if http.statusCode != 200 {
            let body = String(data: data, encoding: .utf8) ?? "(바디를 디코딩할 수 없음)"
            print("🔴 searchBooks: HTTP \(http.statusCode)\n바디:\n\(body)")
            throw URLError(.badServerResponse)
        }

        // 5) 디코딩
        let backendBooks = try JSONDecoder().decode([BackendBook].self, from: data)
        return backendBooks.compactMap { Book(backend: $0) }
    }
}
