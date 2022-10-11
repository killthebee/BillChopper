import Foundation
import CoreData


public class AppUser: NSManagedObject {

    static func create(
        avatar: String? = nil,
        name: String,
        isMale: Bool,
        code: Int16 = 1,
        phone: String,
        context manageObjectConext: NSManagedObjectContext
    ) {
        if avatar == nil {
            let avatar = generateAvater()
        }
        
        let user = AppUser(context: manageObjectConext)
        user.avatar = avatar!
        user.name = name
        user.ismale = isMale
        user.code = code
        user.phone = phone
        
        user.events = nil
        user.ownEvents = nil
        user.ownEvents = nil
        do {
            try manageObjectConext.save()
        } catch {
            let nserror = error as NSError
            fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
        }
    }

}
