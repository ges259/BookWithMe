//
//  Book+Diff.swift
//  BookWithMe
//
//  Created by 계은성 on 6/11/25.
//

import Foundation

// MARK: - diff
extension Book {
    func diff(from old: Book) -> (
        bookPatch: BookPatch,
        historyPatch: BookHistoryPatch,
        reviewPatch: ReviewPatch,
        hasChanged: Bool
    ) {
        var bookPatch      = BookPatch()
        var historyPatch   = BookHistoryPatch()
        var reviewPatch    = ReviewPatch()
        var hasChange      = false
        
        // ✅ Book 필드 비교
        if title       != old.title       { bookPatch.title       = title;         hasChange = true }
        if author      != old.author      { bookPatch.author      = author;        hasChange = true }
        if publisher   != old.publisher   { bookPatch.publisher   = publisher;     hasChange = true }
        if description != old.description { bookPatch.description = description;   hasChange = true }
        if imageURL    != old.imageURL    { bookPatch.imageURL    = imageURL;      hasChange = true }
        
        // ✅ BookHistory 필드 비교
        if history.status     != old.history.status     { historyPatch.status    = history.status;    hasChange = true }
        if history.startDate  != old.history.startDate  { historyPatch.startDate = history.startDate; hasChange = true }
        if history.endDate    != old.history.endDate    { historyPatch.endDate   = history.endDate;   hasChange = true }
        
        // ✅ Review 필드 비교
        let newReview = history.review
        let oldReview = old.history.review
        if newReview.rating          != oldReview.rating          { reviewPatch.rating          = newReview.rating;          hasChange = true }
        if newReview.summary         != oldReview.summary         { reviewPatch.summary         = newReview.summary;         hasChange = true }
        if newReview.detail          != oldReview.detail          { reviewPatch.detail          = newReview.detail;          hasChange = true }
        if newReview.memorableQuotes != oldReview.memorableQuotes { reviewPatch.memorableQuotes = newReview.memorableQuotes; hasChange = true }
        if newReview.tags != oldReview.tags {
            reviewPatch.tags = newReview.tags?.joined(separator: ", ")
            hasChange = true
        }
        
        return (bookPatch, historyPatch, reviewPatch, hasChange)
    }
}
