//
//  BookAPIManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/17/25.
//

import Foundation
enum Secret {
    static var apiKey: String {
        Bundle.main.infoDictionary?["API_KEY"] as? String ?? ""
    }
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

final class BookAPIManager {
    // MARK: - BookAPIManager 내부 Constants 정의
    private struct Constants {
        static let baseURL = "https://www.aladin.co.kr/ttb/api/ItemSearch.aspx"
        static let apiKey = Secret.apiKey
        static let maxResults = "3"
        
        struct QueryKey {
            static let key = "ttbkey"
            static let query = "Query"
            static let queryType = "QueryType"
            static let searchTarget = "SearchTarget"
            static let output = "Output"
            static let cover = "Cover"
            static let start = "start"
            static let maxResults = "MaxResults"
            
        }
        
        struct QueryValue {
            static let queryType = "Title"
            static let searchTarget = "Book"
            static let outputFormat = "JS"
            static let coverSize = "Big"
        }
    }
    
    static let shared = BookAPIManager()
    private init() {}
    
    // MARK: - Public
    func fetchBooksByTitle(
        _ title: String,
        page: Int = 1
    ) async throws -> [Book] {
        let url = try makeSearchURL(title: title, page: page)
        let (rawData, _) = try await URLSession.shared.data(from: url)
        print("URL: \(url)")
        
        let cleanedData: Data = {
            if rawData.last == 0x3B { return Data(rawData.dropLast()) }
            else { return rawData }
        }()
        
        let decoded = try JSONDecoder().decode(AladinSearchResponse.self, from: cleanedData)
        return decoded.items.map { Book(dto: $0) }
    }
    
    // MARK: - URL 생성 함수
    private func makeSearchURL(
        title: String,
        page: Int
    ) throws -> URL {
        var comps = URLComponents(string: Constants.baseURL)
        
        comps?.queryItems = [
            URLQueryItem(name: Constants.QueryKey.key,
                         value: Constants.apiKey),
            URLQueryItem(name: Constants.QueryKey.query,
                         value: title),
            URLQueryItem(name: Constants.QueryKey.queryType,
                         value: Constants.QueryValue.queryType),
            URLQueryItem(name: Constants.QueryKey.searchTarget,
                         value: Constants.QueryValue.searchTarget),
            URLQueryItem(name: Constants.QueryKey.output,
                         value: Constants.QueryValue.outputFormat),
            URLQueryItem(name: Constants.QueryKey.cover,
                         value: Constants.QueryValue.coverSize),
            URLQueryItem(name: Constants.QueryKey.start,
                         value: "\(page)"),
            URLQueryItem(name: Constants.QueryKey.maxResults,
                         value: Constants.maxResults)
        ]
        
        guard let url = comps?.url else {
            throw URLError(.badURL)
        }
        return url
    }
}










// MARK: - 전체 검색 응답
struct AladinSearchResponse: Decodable {
    let items: [AladinBookDTO]

    enum CodingKeys: String, CodingKey {
        case items = "item"
    }
}

// MARK: - 단일 책 DTO
// API의 응답 구조가 바뀌었을 때 앱 내부 로직의 영향을 적게 하기 위해 따로 모델을 둠
struct AladinBookDTO: Decodable {
    let title: String
    let author: String
    let publisher: String
    let description: String?
    let toc: String?
    let cover: String?

    enum CodingKeys: String, CodingKey {
        case title, author, publisher, description, toc, cover
    }
}



/*
 cd /Users/gyeeunseong/Documents/BookWithMe
 echo "BookWithMe/Info.plist" >> .gitignore
 git status
 git rm --cached BookWithMe/Info.plist
 git add .
 git commit -m "Ignore Info.plist and remove from Git tracking"

 */



