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
        Based on the preferences above, recommend exactly \(numTitles) Korean book titles as a single JSON array like the example below:
        ["불편한 편의점", "완득이", "아몬드", "유령이 된 할아버지", "위저드 베이커리", "날씨가 좋으면 찾아가겠어요", "초콜릿 우체국", "82년생 김지영", "미움받을 용기", "돌이킬 수 없는 약속"]
        Do not include any explanation or extra text. Output ONLY the JSON array of book titles.
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
