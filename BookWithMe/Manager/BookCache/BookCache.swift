//
//  BookCache.swift
//  BookWithMe
//
//  Created by 계은성 on 5/16/25.
//

import SwiftUI
import Observation

// MARK: - Observable BookCache
@Observable
final class BookCache {
    static let shared = BookCache()
    
    private init() {
        // ai 책 추천
        self.fetchAIRecommendations()
    }
    
    // 관찰 필요 없는 원본 저장소
    @ObservationIgnored
    var storage: [String: Book] = [:]
    
    // 관측이 필요한 데이터들
    var bookPrefs: BookPrefs = BookPrefs()
    var bookData: [ReadingStatus: [String]] = [:]
}
