//
//  UserEntity+CoreDataProperties.swift
//  BookWithMe
//
//  Created by 계은성 on 7/8/25.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var imageURL: String?
    @NSManaged public var name: String?
    @NSManaged public var userId: String?

}

extension UserEntity : Identifiable {

}
