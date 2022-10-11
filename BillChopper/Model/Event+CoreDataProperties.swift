//
//  Event+CoreDataProperties.swift
//  BillChopper
//
//  Created by danny on 11.10.2022.
//
//

import Foundation
import CoreData


extension Event {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Event> {
        return NSFetchRequest<Event>(entityName: "Event")
    }

    @NSManaged public var avatar: String
    @NSManaged public var name: String
    @NSManaged public var isOneTime: Bool
    @NSManaged public var author: AppUser
    @NSManaged public var users: NSSet
    @NSManaged public var spends: Spend?

}

// MARK: Generated accessors for users
extension Event {

    @objc(addUsersObject:)
    @NSManaged public func addToUsers(_ value: AppUser)

    @objc(removeUsersObject:)
    @NSManaged public func removeFromUsers(_ value: AppUser)

    @objc(addUsers:)
    @NSManaged public func addToUsers(_ values: NSSet)

    @objc(removeUsers:)
    @NSManaged public func removeFromUsers(_ values: NSSet)

}

extension Event : Identifiable {

}
