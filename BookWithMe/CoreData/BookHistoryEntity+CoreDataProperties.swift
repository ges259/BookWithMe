//
//  BookHistoryEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 5/6/25.
//
//

import Foundation
import CoreData


extension BookHistoryEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookHistoryEntity> {
        return NSFetchRequest<BookHistoryEntity>(entityName: "BookHistoryEntity")
    }

    @NSManaged public var bookId: String?
    @NSManaged public var endDate: Date?
    @NSManaged public var startDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var userId: String?
    @NSManaged public var relationship: BookEntity?

}

extension BookHistoryEntity : Identifiable {

}
