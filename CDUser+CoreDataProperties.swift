//
//  CDUser+CoreDataProperties.swift
//  SnapNote
//
//  Created by chaitanya on 23/05/25.
//
//

import Foundation
import CoreData


extension CDUser {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDUser> {
        return NSFetchRequest<CDUser>(entityName: "CDUser")
    }

    @NSManaged public var name: String?
    @NSManaged public var email: String?
    @NSManaged public var profilePictureURL: String?

}

extension CDUser : Identifiable {

}
