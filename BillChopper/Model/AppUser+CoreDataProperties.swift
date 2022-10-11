//
//  AppUser+CoreDataProperties.swift
//  BillChopper
//
//  Created by danny on 11.10.2022.
//
//

import Foundation
import CoreData


extension AppUser {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<AppUser> {
        return NSFetchRequest<AppUser>(entityName: "AppUser")
    }

    @NSManaged public var avatar: String
    @NSManaged public var code: Int16
    @NSManaged public var ismale: Bool
    @NSManaged public var name: String
    @NSManaged public var phone: String
    @NSManaged public var ownEvents: NSSet?
    @NSManaged public var events: NSSet?
    @NSManaged public var ownPayments: NSSet?

}

// MARK: Generated accessors for ownEvents
extension AppUser {

    @objc(addOwnEventsObject:)
    @NSManaged public func addToOwnEvents(_ value: Event)

    @objc(removeOwnEventsObject:)
    @NSManaged public func removeFromOwnEvents(_ value: Event)

    @objc(addOwnEvents:)
    @NSManaged public func addToOwnEvents(_ values: NSSet)

    @objc(removeOwnEvents:)
    @NSManaged public func removeFromOwnEvents(_ values: NSSet)

}

// MARK: Generated accessors for ownPayments
extension AppUser {

    @objc(addOwnPaymentsObject:)
    @NSManaged public func addToOwnPayments(_ value: Spend)

    @objc(removeOwnPaymentsObject:)
    @NSManaged public func removeFromOwnPayments(_ value: Spend)

    @objc(addOwnPayments:)
    @NSManaged public func addToOwnPayments(_ values: NSSet)

    @objc(removeOwnPayments:)
    @NSManaged public func removeFromOwnPayments(_ values: NSSet)

}

extension AppUser : Identifiable {

}
