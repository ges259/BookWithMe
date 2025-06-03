//
//  CoreDataManager.swift
//  BookWithMe
//
//  Created by 계은성 on 6/3/25.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    // 여기에서 context를 가져와서 재사용
    let context: NSManagedObjectContext = PersistenceManager.shared.context
    private init() { }
    
    
    
    // MARK: - 저장
    func saveContext(_ context: NSManagedObjectContext) throws {
        print("DEBUG: createBook --- 6")
        guard context.hasChanges else { return }
        print("DEBUG: createBook --- 7")
        do {
            try context.save()
            print("DEBUG: createBook --- 8")
        } catch {
            /// 원본 오류를 감싼 뒤 상위 호출부로 throw
            throw CoreDataError.saveFailed(underlying: error)
        }
    }
    
    
    // MARK: - Upsert Helper
    @discardableResult
    static func upsert<T: NSManagedObject>(
        entity: T.Type,
        idKey: String,
        idValue: String,
        in context: NSManagedObjectContext,
        configure: (T) -> Void
    ) throws -> T {
        do {
            let request = NSFetchRequest<T>(entityName: String(describing: entity))
            request.predicate  = NSPredicate(format: "%K == %@", idKey, idValue)
            request.fetchLimit = 1
            
            let object = try context.fetch(request).first ?? T(context: context)
            configure(object)
            return object
        } catch {
            /// fetch 실패 → CoreDataError 로 포장
            throw CoreDataError.fetchFailed(underlying: error)
        }
    }
}
