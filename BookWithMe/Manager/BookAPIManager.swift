//
//  BookAPIManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/17/25.
//

import Foundation

final class BookAPIManager {
    // MARK: Constants
    private enum Constants {
        static let searchBaseURL  = "https://www.nl.go.kr/seoji/SearchApi.do"
        static let detailBaseURL  = "https://www.nl.go.kr/seoji/openApiDtl.do"
        static let apiKey         = "<API_KEY_여기에_입력>"
        static let resultStyle    = "json"
        static let pageSize       = "20"
    }
    
    static let shared = BookAPIManager()
    private init() {}
    
    /// '검색어'로 BookEntity 배열을 반환 (Core Data에 저장하지 않음)
    func searchBookEntities(keyword: String, page: Int) async throws -> [BookEntity] {
        let searchURL = try makeSearchURL(keyword: keyword, page: page)
        let (data, _) = try await URLSession.shared.data(from: searchURL)
        let search = try JSONDecoder().decode(SearchResponse.self, from: data)
        
        var results: [BookEntity] = []
        for doc in search.docs {
            if let entity = try? await fetchDetailAsEntity(controlNo: doc.controlNo) {
                results.append(entity)
            }
        }
        return results
    }
}


private extension BookAPIManager {

    /// 상세 정보를 BookEntity로 반환 (Core Data에 저장하지 않음)
    func fetchDetailAsEntity(controlNo: String) async throws -> BookEntity {
        let detailURL = try makeDetailURL(controlNo: controlNo)
        let (data, _) = try await URLSession.shared.data(from: detailURL)
        let decoded = try JSONDecoder().decode(DetailResponse.self, from: data)

        guard let item = decoded.docs.first else {
            throw NSError(domain: "BookAPIManager", code: 404, userInfo: [NSLocalizedDescriptionKey: "상세 정보를 찾을 수 없습니다."])
        }

        // BookEntity 생성, Core Data에 저장하지 않음
        let entity = BookEntity()
        entity.bookId = item.controlNo
        entity.title = item.titleInfo
        entity.author = item.author
        entity.publisher = item.publisher
        entity.bookDescription = item.description
        entity.imageURL = item.coverUrl
        
        // 객체는 저장되지 않고 메모리 내에서만 존재
        return entity
    }

    // MARK: URL 생성
    func makeSearchURL(keyword: String, page: Int) throws -> URL {
        var comps = URLComponents(string: Constants.searchBaseURL)
        comps?.queryItems = [
            .init(name: "cert_key",      value: Constants.apiKey),
            .init(name: "result_style",  value: Constants.resultStyle),
            .init(name: "page_no",       value: String(page)),
            .init(name: "page_size",     value: Constants.pageSize),
            .init(name: "title",         value: keyword)
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        return url
    }

    func makeDetailURL(controlNo: String) throws -> URL {
        var comps = URLComponents(string: Constants.detailBaseURL)
        comps?.queryItems = [
            .init(name: "cert_key",      value: Constants.apiKey),
            .init(name: "result_style",  value: Constants.resultStyle),
            .init(name: "control_no",    value: controlNo)
        ]
        guard let url = comps?.url else { throw URLError(.badURL) }
        return url
    }

    // MARK: Response DTOs
    struct SearchResponse: Decodable {
        let docs: [SearchItem]
        struct SearchItem: Decodable {
            let controlNo: String
        }
    }

    struct DetailResponse: Decodable {
        let docs: [DetailItem]
        struct DetailItem: Decodable {
            let controlNo: String
            let titleInfo: String
            let author: String
            let publisher: String
            let description: String?
            let coverUrl: String?
        }
    }
}
