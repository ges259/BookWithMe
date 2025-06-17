//
//  PersistenceManager.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//

import Foundation
import CoreData

// MARK: - PersistenceManager
/// Core Data 스택을 관리하는 싱글톤 클래스
/// NSPersistentContainer를 초기화하고, viewContext를 외부에 제공
final class PersistenceManager {
    /// 싱글톤 인스턴스. 앱 전체에서 하나의 PersistenceManager만 사용
    static let shared = PersistenceManager()

    /// Core Data 컨테이너 - xcdatamodeld 파일에 정의된 모델을 기반으로 생성
    let container: NSPersistentContainer

    /// 외부에서 접근 가능한 메인 컨텍스트. 대부분의 읽기/쓰기 작업은 이 context를 사용
    var context: NSManagedObjectContext {
        container.viewContext
    }

    /// 초기화 메서드. NSPersistentContainer를 구성하고, 저장소를 로드
    private init() {
        container = NSPersistentContainer(name: "CoreData")

        // Persistent Store를 로드
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                // 저장소 로딩 실패 시 앱을 중단
                fatalError("❌ Unresolved Core Data error \(error), \(error.userInfo)")
            }
        }

        // 병합 정책 설정: 나중에 변경된 값이 우선됨 (충돌 시)
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        // 부모 컨텍스트의 변경 사항을 자동으로 반영하도록 설정
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
