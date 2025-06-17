//
//  FetchBookPrefs.swift
//  BookWithMe
//
//  Created by 계은성 on 6/2/25.
//

import Foundation
import CoreData

extension CoreDataManager {
    // MARK: - Read
    /// BookPrefs 데이터를 fetch하여 최신 항목 1개를 반환
    /// - 데이터가 없거나 에러가 발생하면 기본값(BookPrefs())을 반환
    func fetchBookPrefs() -> BookPrefs {
        let request: NSFetchRequest<BookPrefsEntity> = BookPrefsEntity.fetchRequest()
        request.fetchLimit = 1
        
        guard let entity = try? context.fetch(request).first else {
            return BookPrefs()
        }
        
        return BookPrefs(entity: entity) ?? BookPrefs()
    }
}
