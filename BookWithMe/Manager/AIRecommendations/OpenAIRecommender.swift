//
//  OpenAIRecommender.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

// MARK: - OpenAIRecommender
enum OpenAIRecommender {
    static let apiKey = APIKey.openai_Key
    static let model = "gpt-4o"

    static func fetchTitles(prefs: [String: [String]], numTitles: Int) async -> [String] {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return [] }
        
        // 1) 시스템 프롬프트 (영어)
        let system = """
        You are an expert in recommending Korean books. Recommend exactly \(numTitles) book titles as a JSON array.
        All recommended books must match ALL genres in the 'likedGenres' list—do not recommend any book that does not fit these genres. NEVER include books from any 'dislikedGenres'.
        Age group, page length, language, and reading purpose must also be reflected as much as possible.
        All books must be currently in print and searchable by exact title on major Korean bookstores (Aladin, Yes24, Kyobo, etc).
        Never recommend out-of-print, rare, or foreign-only books.
        If there are not enough perfect matches, recommend similar and widely available Korean books instead.
        """

        // 2) 출력 지시문 (영어)
        let instruction = """
        You are a Korean keyword generator.

        If 'likedGenres' is not empty:
        - Generate exactly 10 unique and meaningful Korean keywords that are thematically relevant to **all genres listed in 'likedGenres'**.
        - Each keyword should reflect common themes, settings, or motifs found in those genres.
        - Avoid repetition or generic terms.

        If 'likedGenres' is empty:
        - Instead of keywords, return the titles of 10 different, well-known Korean bestseller books.
        - These books must be **real**, widely recognized, and currently available on major Korean bookstores such as Aladin, Yes24, or Kyobo.
        - Ensure that the list does not include duplicate titles or outdated classics unless they are still actively popular.
        
        Return only the result as a JSON array with no explanation or extra text.

        Format:
        ["키워드 또는 제목 1", "키워드 또는 제목 2", ..., "키워드 또는 제목 10"]
        
        """
        
        let messages: [[String: String]] = [
            ["role": "system", "content": system],
            ["role": "user", "content": prefs.jsonString()],
            ["role": "user", "content": instruction]
        ]
        
        let body: [String: Any] = [
            "model": model,
            "messages": messages,
            "temperature": 0.7,
            "max_tokens": 512
        ]

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: req)
            print("📤 OpenAI 요청 메시지:", messages)
            print("📥 OpenAI 응답 Raw:", String(data: data, encoding: .utf8) ?? "")
            if let content = try? JSONDecoder().decode(OpenAIResponse.self, from: data).choices.first?.message.content,
               let result = try? JSONDecoder().decode([String].self, from: Data(content.utf8)) {
                return result
            }
        } catch {
            print("OpenAI 에러:", error)
        }

        return []
    }
}
