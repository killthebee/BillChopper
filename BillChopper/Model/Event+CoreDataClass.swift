//
//  Event+CoreDataClass.swift
//  BillChopper
//
//  Created by danny on 11.10.2022.
//
//

import Foundation
import CoreData

@objc(Event)
public class Event: NSManagedObject {
    
    static func create(
            avatar: String? = nil,
            name: String,
            isOneTime: Bool = false,
            author: AppUser,
            users: [AppUser],
            spends: [Spend]? = nil,
            context manageObjectConext: NSManagedObjectContext
        ) {
            if avatar == nil {
                let avatar = generateAvater()
            }
            
            let event = Event(context: manageObjectConext)
            event.name = name
            event.avatar = avatar!
            event.isOneTime = isOneTime
            event.author = author
            event.users = NSSet(array: users)
            
            // logic for one timers
            do {
                try manageObjectConext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
            }
        }
}
