//
//  ReviewEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 5/9/25.
//
//

import Foundation
import CoreData


extension ReviewEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewEntity> {
        return NSFetchRequest<ReviewEntity>(entityName: "ReviewEntity")
    }

    @NSManaged public var bookId: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var memorableQuotes: String?
    @NSManaged public var rating: Int16
    @NSManaged public var reviewDetail: String?
    @NSManaged public var reviewSummary: String?
    @NSManaged public var tags: String?
    @NSManaged public var book: BookEntity?

}

extension ReviewEntity : Identifiable {

}
