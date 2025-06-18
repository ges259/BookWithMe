//
//  BookDataViewModel+Persistence.swift
//  BookWithMe
//
//  Created by 계은성 on 6/18/25.
//

import Foundation

extension BookDataViewModel {
    /// 저장 버튼 눌렀을 때 실행됨. 저장 여부에 따라 분기 처리.
    func saveBook() {
        Task { @MainActor in
            do {
                let baseData = self.bookCache.book(id: book.id)
                
                
                if self.isSavedBook && baseData?.history.status != .recommended {
                    print("1")
                    try await updateBookIfNeeded()
                    self.bookCache.update(book)
                } else {
                    print("2")
                    try await createBook()
                    self.bookCache.store(book)
                }

                self.showSaveButton = false
            } catch {
                log(error, context: "saveBook")
            }
        }
    }

    /// 새로운 책을 Core Data에 저장함
    private func createBook() async throws {
        print("3")
        try await self.coreDataManager.save(book: book)
    }

    /// 변경사항이 있는 경우 Core Data에 업데이트함
    private func updateBookIfNeeded() async throws {
        guard let diffResult = self.diffFromCachedBook() else { return }

        try await self.coreDataManager.update(
            bookId: book.id,
            bookPatch: diffResult.bookPatch,
            historyPatch: diffResult.historyPatch,
            reviewPatch: diffResult.reviewPatch
        )
    }

    /// 캐시된 책과 현재 책을 비교해서 변경사항이 있으면 diff 결과를 반환
    func diffFromCachedBook() -> (
        bookPatch: BookPatch,
        historyPatch: BookHistoryPatch,
        reviewPatch: ReviewPatch,
        hasChanged: Bool
    )? {
        guard let originalBook = self.bookCache.book(id: self.book.id) else { return nil }
        return book.diff(from: originalBook)
    }

    /// 에러가 발생했을 때 로그 출력용
    private func log(_ error: Error, context: String) {
        print("\(context) -- DEBUG: \(error.localizedDescription)")
    }

    /// 책 삭제 처리 (CoreData + 캐시)
    func deleteBook() {
        Task { @MainActor in
            do {
                try await self.coreDataManager.delete(bookId: self.book.id)
                self.bookCache.delete(book.id)
            } catch {
                log(error, context: #function)
            }
        }
    }
}
