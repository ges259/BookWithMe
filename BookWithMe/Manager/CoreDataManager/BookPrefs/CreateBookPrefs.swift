//
//  CreateBookPrefs.swift
//  BookWithMe
//
//  Created by 계은성 on 6/2/25.
//

import Foundation
import CoreData


extension CoreDataManager {
    // MARK: Create / Update (Upsert)
    /// BookPrefs 모델을 저장하거나 업데이트
    /// - 모델이 이미 존재하면 해당 모델을 업데이트하고, 존재하지 않으면 새로 생성
    func save(bookPrefs model: BookPrefs) async throws {
        try await PersistenceManager.shared.container.performBackgroundTask { context in
            // 기존의 BookPrefsEntity가 존재하는지 확인
            let existingPrefs = try self.fetchExistingPrefs(in: context)
            
            // 기존의 데이터가 존재하면 업데이트, 존재하지 않으면 새로 생성
            if let prefs = existingPrefs {
                self.updatePrefs(prefs, with: model)
            } else {
                self.createPrefs(with: model, in: context)
            }
            
            // 변경된 사항을 저장
            try self.saveContext(context)
        }
    }
    
    // MARK: - Helper Methods
    
    /// 기존의 BookPrefsEntity가 존재하는지 확인
    /// - Context에서 `BookPrefsEntity`를 fetch하여 존재하는지 확인
    /// - 존재하는 데이터가 있으면 반환
    private func fetchExistingPrefs(
        in context: NSManagedObjectContext
    ) throws -> BookPrefsEntity? {
        let fetchRequest: NSFetchRequest<BookPrefsEntity> = BookPrefsEntity.fetchRequest()
        // 최대 1개만 조회
        fetchRequest.fetchLimit = 1
        // 첫 번째 데이터 반환
        return try context.fetch(fetchRequest).first
    }
    
    /// 기존 BookPrefsEntity를 업데이트
    /// - 기존 BookPrefsEntity에 새로운 값으로 업데이트
    /// - 모델의 각 속성을 `toCommaSeparated` 메서드를 통해 저장
    private func updatePrefs(
        _ prefs: BookPrefsEntity,
        with model: BookPrefs
    ) {
        prefs.language = model.language.toCommaSeparated
        prefs.pageLength = model.pageLength.toCommaSeparated
        prefs.ageGroup = model.ageGroup.toCommaSeparated
        prefs.readingPurpose = model.readingPurpose.toCommaSeparated
        prefs.likedGenres = model.likedGenres.toCommaSeparated
        prefs.dislikedGenres = model.dislikedGenres.toCommaSeparated
    }
    
    /// 새로운 BookPrefsEntity 생성
    /// - 모델을 사용하여 새로운 `BookPrefsEntity`를 생성
    /// - 모델의 각 속성을 `toCommaSeparated` 메서드를 통해 저장
    private func createPrefs(
        with model: BookPrefs,
        in context: NSManagedObjectContext
    ) {
        let newPrefs = BookPrefsEntity(context: context)
        newPrefs.language = model.language.toCommaSeparated
        newPrefs.pageLength = model.pageLength.toCommaSeparated
        newPrefs.ageGroup = model.ageGroup.toCommaSeparated
        newPrefs.readingPurpose = model.readingPurpose.toCommaSeparated
        newPrefs.likedGenres = model.likedGenres.toCommaSeparated
        newPrefs.dislikedGenres = model.dislikedGenres.toCommaSeparated
    }
}
