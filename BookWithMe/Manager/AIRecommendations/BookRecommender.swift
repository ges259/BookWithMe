//
//  BookRecommender.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - BookRecommender
final class BookRecommender {
    static let shared = BookRecommender()

    func fetchRecommendedBooks(
        prefs: [String: [String]],
        count: Int = 5
    ) async -> [Book] {
        print("🚀 [추천 시작] 원본 prefs:", prefs)
        
        let relaxPriority = [
            "ageGroup", "pageLength", "language",
            "dislikedGenres", "readingPurpose", "likedGenres"
        ]
        let relaxOrder = RelaxEngine.makeRelaxOrder(prefs: prefs, priority: relaxPriority)
        print("📊 relaxOrder:", relaxOrder)

        var foundBooks: [Book] = []
        let fallbackGenre = prefs["likedGenres"]?.first ?? "문학"

        for (index, relaxFields) in relaxOrder.enumerated() {
            var trialPrefs = prefs
            for field in relaxFields {
                trialPrefs.removeValue(forKey: field)
            }
            print("🔁 [\(index)] 조건 완화 후 prefs:", trialPrefs)

            let titles = await OpenAIRecommender.fetchTitles(prefs: trialPrefs, numTitles: 1)
            print("📚 GPT 추천 키워드:", titles)

            guard let keyword = titles.first else {
                print("⚠️ GPT 추천 결과 없음 → 다음 relax 단계로")
                continue
            }

            var books = await AladinAPI.searchBooks(query: keyword, wantCount: count)
            print("📖 알라딘 검색 결과: \(books.count)권")

            if books.count >= count {
                print("✅ 책 충분함 → 추천 완료")
                return Array(books.prefix(count))
            }

            if !books.isEmpty {
                foundBooks = books
            }

            if index == relaxOrder.count - 1, books.count < count {
                print("🔄 마지막 단계 → fallback으로 \(fallbackGenre) 보충")
                let existingIds = Set(books.map { $0.id })
                let fill = await AladinAPI.fetchGenreBooks(
                    count - books.count,
                    genre: fallbackGenre,
                    excludeIds: existingIds
                )
                books += fill
                print("📦 fallback 추가 후 총:", books.count)
                return Array(books.prefix(count))
            }
        }

        print("⚠️ 모든 단계 실패 → 결과:", foundBooks.count)
        return foundBooks
    }
}
