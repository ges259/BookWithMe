//
//  BookEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 5/5/25.
//
//

import Foundation
import CoreData


extension BookEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookEntity> {
        return NSFetchRequest<BookEntity>(entityName: "BookEntity")
    }

    @NSManaged public var bookId: String?
    @NSManaged public var bookName: String?
    @NSManaged public var imagePath: String?

}

extension BookEntity : Identifiable {

}
