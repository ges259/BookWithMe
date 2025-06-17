//
//  BookPrefsEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 6/2/25.
//
//

import Foundation
import CoreData


extension BookPrefsEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookPrefsEntity> {
        return NSFetchRequest<BookPrefsEntity>(entityName: "BookPrefsEntity")
    }

    @NSManaged public var language: String?
    @NSManaged public var pageLength: String?
    @NSManaged public var ageGroup: String?
    @NSManaged public var readingPurpose: String?
    @NSManaged public var likedGenres: String?
    @NSManaged public var dislikedGenres: String?

}

extension BookPrefsEntity : Identifiable {

}
