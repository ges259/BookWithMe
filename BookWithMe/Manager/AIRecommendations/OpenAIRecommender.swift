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

        let system = """
        You are an expert in recommending Korean books. Recommend exactly \(numTitles) titles...
        """

        let instruction = """
        Based on the preferences above, recommend exactly \(numTitles) Korean book titles as a JSON array like:
        ["불편한 편의점", "아몬드", ...] — ONLY the array, no explanation.
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
