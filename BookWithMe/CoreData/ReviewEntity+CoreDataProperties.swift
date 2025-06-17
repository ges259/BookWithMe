//
//  ReviewEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//
//

import Foundation
import CoreData


extension ReviewEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReviewEntity> {
        return NSFetchRequest<ReviewEntity>(entityName: "ReviewEntity")
    }

    @NSManaged public var memorableQuotes: String?
    @NSManaged public var rating: Double
    @NSManaged public var reviewDetail: String?
    @NSManaged public var reviewId: String?
    @NSManaged public var reviewSummary: String?
    @NSManaged public var tags: String?
    @NSManaged public var updatedAt: Date?
    @NSManaged public var bookHistory: BookHistoryEntity?

}

extension ReviewEntity : Identifiable {

}
