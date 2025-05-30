//
//  BookEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 5/28/25.
//
//

import Foundation
import CoreData


extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var author: String?
    @NSManaged public var bookDescription: String?
    @NSManaged public var bookId: String?
    @NSManaged public var imageURL: String?
    @NSManaged public var publisher: String?
    @NSManaged public var title: String?
    @NSManaged public var keywords: String?
    @NSManaged public var bookHistory: BookHistoryEntity?

}

extension BookEntity : Identifiable {

}
