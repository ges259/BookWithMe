//
//  BookHistoryEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 7/8/25.
//
//

import Foundation
import CoreData


extension BookHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookHistoryEntity> {
        return NSFetchRequest<BookHistoryEntity>(entityName: "BookHistoryEntity")
    }

    @NSManaged public var bookHistoryId: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var book: BookEntity?
    @NSManaged public var review: ReviewEntity?

}

extension BookHistoryEntity : Identifiable {

}
