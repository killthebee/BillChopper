import Foundation
import CoreData


extension Spend {

    @nonobjc public class func createFetchRequest() -> NSFetchRequest<Spend> {
        return NSFetchRequest<Spend>(entityName: "Spend")
    }

    @NSManaged public var difference: Int16
    @NSManaged public var name: String
    @NSManaged public var total: Int16
    @NSManaged public var payeer: AppUser
    @NSManaged public var event: Event

}

extension Spend : Identifiable {

}
