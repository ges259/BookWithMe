//
//  BookRecommender.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

/*
  1. 모든 조건이 비어있을 경우 베스트셀러 반환
  2. 책 추천(조건을 완화해감)
  3. 코어데이터와 비교하여 중복을 제거
  4. 결과를 코어데이터에 저장
 */

final class BookRecommender {
    static let shared = BookRecommender()
    private init() {}

    private let numAladinCount: Int = 1
    private let numKeyWords: Int = 9

    /// 사용자의 선호 조건(prefs)을 기반으로 책을 추천해주는 메인 함수
    /// 조건이 모두 비어있으면 베스트셀러를 추천하고,
    /// 아니면 조건을 완화해가며 GPT + 알라딘 API를 이용해 책을 추천한다.
    /// - Parameters:
    ///   - recentBooks: 사용자의 최근 독서 이력
    ///   - prefs: 사용자의 책 선호 조건
    /// - Returns: 추천된 Book 리스트 (최소 1권 이상, 최대 9권까지 반환)
    func fetchRecommendedBooks(
        recentBooks: [Book],
        prefs: BookPrefs
    ) async -> [Book] {
        let prefsDict = prefs.toStringArrays()
        print("[추천 시작] 원본 prefs:", prefsDict)

        // 모든 조건이 비어있을 경우 베스트셀러 반환
        if isEmptyPrefs(prefsDict) {
            return await AladinAPI.fetchBestSellers(count: numAladinCount)
        }

        // 책 추천(조건을 완화해감)
        let result = await attemptRelaxedRecommendations(
            prefsDict: prefsDict,
            recentBooks: recentBooks
        )
        
        // 코어데이터와 비교하여 중복을 제거
        
        
        // 결과를 코어데이터에 저장
        
        
        // 결과 출력 (디버깅용)
        print(String(repeating: "_", count: 33))
        result.forEach { print($0.title) }
        print(String(repeating: "_", count: 33))

        return result
    }

    /// 조건을 완화해가며 추천을 시도하는 내부 함수
    /// - Parameters:
    ///   - prefsDict: 문자열 배열 형태의 사용자 조건
    ///   - recentBooks: 사용자의 최근 독서 이력
    /// - Returns: 추천된 Book 리스트
    private func attemptRelaxedRecommendations(
        prefsDict: [String: [String]],
        recentBooks: [Book]
    ) async -> [Book] {
        let relaxOrder = makeRelaxOrder(from: prefsDict)
        let fallbackGenre = prefsDict["likedGenres"]?.first ?? "문학"
        var foundBooks: [Book] = []

        for (index, relaxFields) in relaxOrder.enumerated() {
            // 현재 단계에서 제외할 조건 적용
            let trialPrefs = relaxPrefs(prefsDict, by: relaxFields)
            print("[\(index)] 조건 완화 후 prefs:", trialPrefs)

            // GPT 키워드 기반으로 알라딘 검색
            let books = await fetchBooksFromKeywords(
                recentBooks: recentBooks,
                trialPrefs: trialPrefs
            )

            print("알라딘 검색 결과: \(books.count)권")

            // 원하는 수만큼 찾으면 즉시 반환
            if books.count >= numKeyWords {
                return Array(books.prefix(numKeyWords))
            }

            // 일부라도 있으면 보관
            if !books.isEmpty {
                foundBooks = books
            }

            // 마지막 시도에서는 fallback 장르로 보완
            if index == relaxOrder.count - 1 {
                let fallback = await fallbackBooks(
                    fallbackGenre: fallbackGenre,
                    currentBooks: books
                )
                return Array(fallback.prefix(numKeyWords))
            }
        }

        // 아무 조건도 만족하지 못했을 경우 일부라도 반환
        return foundBooks
    }

    /// GPT 추천 키워드를 바탕으로 알라딘에서 책을 검색하고 리스트 생성
    private func fetchBooksFromKeywords(
        recentBooks: [Book],
        trialPrefs: [String: [String]]
    ) async -> [Book] {
        // GPT로부터 추천 키워드 목록 가져오기
        let keywords = await fetchRecommendedKeywords(
            recentBooks: recentBooks,
            for: trialPrefs
        )

        var books: [Book] = []
        // 각 키워드로 알라딘 검색
        for keyword in keywords {
            let result = await AladinAPI.searchBooks(
                query: keyword,
                wantCount: numAladinCount
            )

            // 중복 제거 후 추가
            for book in result where !books.contains(where: { $0.id == book.id }) {
                books.append(book)
            }

            // 목표 개수에 도달하면 중단
            if books.count >= numKeyWords {
                break
            }
        }
        return books
    }

    // MARK: - Helper Functions

    /// 모든 조건이 비어있는지 확인하는 함수
    private func isEmptyPrefs(_ prefs: [String: [String]]) -> Bool {
        return prefs.values.allSatisfy { $0.isEmpty }
    }

    /// RelaxEngine을 사용해 조건을 어느 순서로 포기할지 결정
    private func makeRelaxOrder(from prefs: [String: [String]]) -> [[String]] {
        let priority = [
            "ageGroup",
            "pageLength",
            "language",
            "dislikedGenres",
            "readingPurpose",
            "likedGenres"
        ]
        return RelaxEngine.makeRelaxOrder(prefs: prefs, priority: priority)
    }

    /// 특정 조건들을 제거한 새로운 조건 사전 생성
    private func relaxPrefs(_ prefs: [String: [String]], by removing: [String]) -> [String: [String]] {
        var copy = prefs
        for key in removing {
            copy.removeValue(forKey: key)
        }
        return copy
    }

    /// GPT에서 추천받은 키워드 리스트 반환
    private func fetchRecommendedKeywords(
        recentBooks: [Book],
        for prefs: [String: [String]]
    ) async -> [String] {
        let titles = await OpenAIRecommender.fetchTitles(
            recentBooks: recentBooks,
            prefs: prefs,
            numTitles: self.numKeyWords
        )
        print("GPT 추천 키워드:", titles)
        return titles
    }

    /// 부족한 추천 결과를 fallback 장르로 보완하는 함수
    private func fallbackBooks(
        fallbackGenre: String,
        currentBooks: [Book]
    ) async -> [Book] {
        let existingIds = Set(currentBooks.map { $0.id })
        let fill = await AladinAPI.fetchGenreBooks(
            numAladinCount - currentBooks.count,
            genre: fallbackGenre,
            excludeIds: existingIds
        )
        print("fallback 추가 후 총:", currentBooks.count + fill.count)
        return currentBooks + fill
    }
}
