////
////  AIRecommendations.swift
////  BookWithMe
////
////  Created by 계은성 on 6/4/25.
////

import Foundation

//import Foundation
//
//final class AIRecommendations {
//    static let shared: AIRecommendations = AIRecommendations()
//    private init() {}
//    
//    // 실제 기기용
//    private let baseURL = URL(string: "http://192.168.45.251:5001")!
//
//
//    func fetchRecommendedBooks(
//        userPrefs: BookPrefs,
//        completion: @escaping ([Book]) -> Void
//    ) {
//        
//        guard
//            let url = URL(string: "\(baseURL)/recommend"),
//            let body = makeRecommendationPayload(userPrefs: userPrefs.toStringArrays())
//        else {
//            print("❌ 페이로드 생성 실패")
//            completion([])
//            return
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//        request.httpBody = body
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        URLSession.shared.dataTask(with: request) { data, response, error in
//            if let error = error {
//                print("❌ 요청 에러:", error)
//                completion([])
//                return
//            }
//            if let http = response as? HTTPURLResponse {
//                print("▶️ HTTP statusCode:", http.statusCode)
//            }
//            guard let data = data else {
//                print("❌ 응답 데이터 없음")
//                completion([])
//                return
//            }
//            // 디코딩
//            let decoder = JSONDecoder()
//            decoder.dateDecodingStrategy = .iso8601
//            do {
//                let books = try decoder.decode([Book].self, from: data)
//                print("✅ 파싱된 책 개수:", books.count)
//                DispatchQueue.main.async {
//                    completion(books)
//                }
//            } catch {
//                print("❌ 디코딩 실패:", error)
//                print("📥 raw JSON response:\n", String(data: data, encoding: .utf8) ?? "")
//                completion([])
//            }
//        }
//        .resume()
//    }
//
//    private func makeRecommendationPayload(
//        userPrefs: [String:[String]]
//    ) -> Data? {
//        guard
//            let language       = userPrefs["language"],
//            let pageLength     = userPrefs["pageLength"],
//            let ageGroup       = userPrefs["ageGroup"],
//            let readingPurpose = userPrefs["readingPurpose"],
//            let likedGenres    = userPrefs["likedGenres"],
//            let dislikedGenres = userPrefs["dislikedGenres"]
//        else { return nil }
//        let req = RecommendationRequest(
//            language:       language,
//            pageLength:     pageLength,
//            ageGroup:       ageGroup,
//            readingPurpose: readingPurpose,
//            likedGenres:    likedGenres,
//            dislikedGenres: dislikedGenres,
//            maxResults:     10
//        )
//        let encoder = JSONEncoder()
//        encoder.dateEncodingStrategy = .iso8601
//        return try? encoder.encode(req)
//    }
//}
//
//struct RecommendationRequest: Codable {
//    let language: [String]
//    let pageLength: [String]
//    let ageGroup: [String]
//    let readingPurpose: [String]
//    let likedGenres: [String]
//    let dislikedGenres: [String]
//    let maxResults: Int
//}
