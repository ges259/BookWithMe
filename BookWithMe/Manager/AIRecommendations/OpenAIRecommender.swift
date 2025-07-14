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
    
    
    
    
    /// 사용자의 취향과 최근 읽은 책을 기반으로 OpenAI로부터 책 제목을 추천받는 함수
    ///
    /// - Parameters:
    ///   - recentBooks: 사용자의 최근 독서 이력
    ///   - prefs: 사용자의 도서 선호 조건
    ///   - numTitles: 추천받을 책 제목 개수
    /// - Returns: 추천된 책 제목 배열
    static func fetchTitles(
        recentBooks: [Book],
        prefs: [String: [String]],
        numTitles: Int
    ) async -> [String] {
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return [] }

        let prefsInfo = """
        - 선호 장르(likedGenres): \(prefs["likedGenres"]?.joined(separator: ", ") ?? "없음")
        - 비선호 장르(dislikedGenres): \(prefs["dislikedGenres"]?.joined(separator: ", ") ?? "없음")
        - 언어(language): \(prefs["language"]?.joined(separator: ", ") ?? "없음")
        - 독서 목적(readingPurpose): \(prefs["readingPurpose"]?.joined(separator: ", ") ?? "없음")
        - 연령대(ageGroup): \(prefs["ageGroup"]?.joined(separator: ", ") ?? "없음")
        - 분량(pageLength): \(prefs["pageLength"]?.joined(separator: ", ") ?? "없음")
        """
        
        
        // 1. 시스템 역할 정의 (정책)
        let system = """
        당신은 한국 도서 추천에 특화된 전문가입니다. 사용자의 취향을 반영하여 정확히 \(numTitles)개의 책 제목을 JSON 배열로 추천해주세요.

        모든 추천 도서는 반드시 'likedGenres'에 포함된 **모든 장르**와 일치해야 합니다. 'dislikedGenres'에 포함된 장르의 책은 **절대 추천하지 마세요**.

        가능한 한 나이대, 책 분량, 언어, 독서 목적 등 사용자의 선호 조건을 모두 반영하세요.

        추천되는 책은 반드시 현재 절판되지 않았으며, 알라딘·예스24·교보문고 등의 대형 온라인 서점에서 **정확한 제목으로 검색 가능한 실제 한국 도서**여야 합니다.

        완벽하게 일치하는 책이 부족할 경우, 사용자의 최근 독서 이력과 비슷한 테마나 장르의 **유사하지만 잘 알려진 대중적인 한국 도서**로 추천을 대체해도 됩니다.
        """

        // 2. 유저 지시문 (실제 키워드 요청 + 최근 독서 이력 반영)
        let recentBooksInfo = recentBooks.map {
            "- 제목: \($0.title)\n  키워드: \($0.category.joined(separator: ", "))"
        }.joined(separator: "\n")

        let instruction = """
        사용자의 최근 독서 이력과 사용자의 선호 정보를 반영하여, 현재 구매 가능한 실제 한국 도서 제목을 \(numTitles)개 추천해주세요.

        📌 조건:
        - 'language'가 "한국 도서만"일 경우:
          → 반드시 한국인이 저자이며, 한국에서 출간된 도서만 포함하세요.
          → 외국 작가의 번역서, 해외 문학, 외국 고전은 절대 포함하지 마세요.
        - 추천 도서는 반드시 'likedGenres'에 포함된 모든 장르와 일치해야 합니다.
        - 'dislikedGenres'에 포함된 장르의 책은 절대 추천하지 마세요.
        - 가능한 한 나이대, 책 분량, 언어, 독서 목적 등의 사용자의 선호 조건을 모두 반영해주세요.
        - 절판 도서가 아니며, 알라딘·예스24·교보문고 등의 대형 서점에서 **정확한 제목으로 검색 가능한 실제 도서**여야 합니다.
        - 사용자의 최근 독서 이력과 **너무 유사하거나 동일한 제목은 제외**해주세요.
        
        📖 최근 읽은 책:
        \(recentBooksInfo)

        📌 사용자의 선호 정보:
        \(prefsInfo)
        
        📤 출력 형식:
        정확히 \(numTitles)개의 도서 제목을 **아래 형식의 JSON 배열**로만 출력하세요. 설명이나 다른 문장은 포함하지 마세요.

        형식:
        ["책 제목 1", ..., "책 제목 \(numTitles)"]
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

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        do {
            let (data, _) = try await URLSession.shared.data(for: request)

            print("📤 OpenAI 요청 메시지:", messages)
            print("📥 OpenAI 응답 Raw:", String(data: data, encoding: .utf8) ?? "")

            if let content = try? JSONDecoder().decode(OpenAIResponse.self, from: data).choices.first?.message.content {
                let cleaned = content
                    .replacingOccurrences(of: "```json", with: "")
                    .replacingOccurrences(of: "```", with: "")
                    .trimmingCharacters(in: .whitespacesAndNewlines)

                if let result = try? JSONDecoder().decode([String].self, from: Data(cleaned.utf8)) {
                    return result
                } else {
                    print("⚠️ JSON 배열 파싱 실패: \(cleaned)")
                }
            } else {
                print("⚠️ 응답 content 파싱 실패")
            }
        } catch {
            print("❌ OpenAI 네트워크 에러:", error)
        }

        return []
    }

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
//    static func fetchTitles(
//        recentBooks: [Book],
//        prefs: [String: [String]],
//        numTitles: Int
//    ) async -> [String] {
//        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else { return [] }
//        
//        // 1) System Prompt
//        let system = """
//        당신은 한국 도서 추천에 특화된 전문가입니다. 사용자의 취향을 반영하여 정확히 \(numTitles)개의 책 제목을 JSON 배열로 추천해주세요.
//
//        모든 추천 도서는 반드시 'likedGenres'에 포함된 **모든 장르**와 일치해야 합니다. 'dislikedGenres'에 포함된 장르의 책은 **절대 추천하지 마세요**.
//
//        가능한 한 나이대, 책 분량, 언어, 독서 목적 등 사용자의 선호 조건을 모두 반영하세요.
//
//        추천되는 책은 반드시 현재 절판되지 않았으며, 알라딘·예스24·교보문고 등의 대형 온라인 서점에서 **정확한 제목으로 검색 가능한 실제 한국 도서**여야 합니다.
//
//        완벽하게 일치하는 책이 부족할 경우, 사용자의 최근 독서 이력과 비슷한 테마나 장르의 **유사하지만 잘 알려진 대중적인 한국 도서**로 추천을 대체해도 됩니다.
//        """
//
//        // 2) User Instruction Prompt
//        let instruction = """
//        당신은 한국 도서 추천을 위한 키워드 생성 전문가입니다.
//
//        - 'likedGenres'가 비어 있지 않은 경우:
//          • 해당 장르(복수일 수 있음)의 **공통적인 주제, 분위기, 배경, 모티프**를 반영하는
//            **의미 있고 고유한 한국어 키워드 10개**를 생성하세요.
//          • 각 키워드는 검색어로 사용될 수 있을 만큼 구체적이고 현실적인 단어나 짧은 구절이어야 합니다.
//          • 키워드는 서로 중복되거나 너무 일반적이지 않도록 유의하세요. (예: "감성", "책", "마음" 등은 제외)
//
//        - 'likedGenres'가 비어 있는 경우:
//          • 대신 **현재 한국 대형 서점(알라딘, 예스24, 교보문고 등)**에서 구매 가능한
//            실제 유명 베스트셀러 책 제목 \(numTitles)개를 추천해주세요.
//
//        📌 주의사항:
//        - 최근에 사용자가 읽은 책들과 **너무 유사하거나 똑같은 키워드/제목은 피해주세요**.
//        - 모든 결과는 반드시 아래와 같은 **JSON 배열 형식**으로만 반환해야 하며, 설명이나 부가 텍스트 없이 리스트만 출력하세요.
//
//        형식:
//        ["키워드 또는 제목 1", ..., "키워드 또는 제목 \(numTitles)"]
//        """
//        
//        let messages: [[String: String]] = [
//            ["role": "system", "content": system],
//            ["role": "user", "content": prefs.jsonString()],
//            ["role": "user", "content": instruction]
//        ]
//        
//        let body: [String: Any] = [
//            "model": model,
//            "messages": messages,
//            "temperature": 0.7,
//            "max_tokens": 512
//        ]
//
//        var req = URLRequest(url: url)
//        req.httpMethod = "POST"
//        req.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        req.httpBody = try? JSONSerialization.data(withJSONObject: body)
//
//        do {
//            let (data, _) = try await URLSession.shared.data(for: req)
//            print("📤 OpenAI 요청 메시지:", messages)
//            print("📥 OpenAI 응답 Raw:", String(data: data, encoding: .utf8) ?? "")
//            if let content = try? JSONDecoder().decode(OpenAIResponse.self, from: data).choices.first?.message.content,
//               let result = try? JSONDecoder().decode([String].self, from: Data(content.utf8)) {
//                return result
//            }
//        } catch {
//            print("OpenAI 에러:", error)
//        }
//
//        return []
//    }
}
