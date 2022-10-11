//
//  Spend+CoreDataClass.swift
//  BillChopper
//
//  Created by danny on 11.10.2022.
//
//

import Foundation
import CoreData

@objc(Spend)
public class Spend: NSManagedObject {
    
    static func create(
            name: String,
            difference: Int16,
            total: Int16,
            payeer: AppUser,
            event: Event,
            context manageObjectConext: NSManagedObjectContext
        ) {
            
            let spend = Spend(context: manageObjectConext)
            spend.name = name
            spend.difference = difference
            spend.total = total
            spend.event = event
            
            do {
                try manageObjectConext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
            }
        }
}
