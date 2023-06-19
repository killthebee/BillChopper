import CoreData

struct CoreDataManager {

    static let shared = CoreDataManager()

    let persistentContainer: NSPersistentContainer = {

        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error {
                fatalError("Loading of store failed \(error)")
            }
        }

        return container
    }()
    
    @discardableResult
    func createAppUser(username: String, phone: String, isMale: Bool) -> AppUser? {
        let context = persistentContainer.viewContext
        let appUser = AppUser(context: context)

        appUser.username = username
        appUser.phone = phone
        appUser.isMale = isMale
        do {
            try context.save()
            return appUser
        } catch let error {
            print("Failed to create: \(error)")
        }

        return nil
    }

    func fetchAppUser() -> AppUser? {
        let context = persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<AppUser>(entityName: "AppUser")

        do {
            let appUser = try context.fetch(fetchRequest)
            if appUser.count != 1 { return nil }
            return appUser[0]
        } catch let error {
            print("Failed to fetch companies: \(error)")
        }

        return nil
    }
//
//    func fetchEmployee(withName name: String) -> Employee? {
//        let context = persistentContainer.viewContext
//
//        let fetchRequest = NSFetchRequest<Employee>(entityName: "Employee")
//        fetchRequest.fetchLimit = 1
//        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
//
//        do {
//            let employees = try context.fetch(fetchRequest)
//            return employees.first
//        } catch let error {
//            print("Failed to fetch: \(error)")
//        }
//
//        return nil
//    }
//
//    func updateEmployee(employee: Employee) {
//        let context = persistentContainer.viewContext
//
//        do {
//            try context.save()
//        } catch let error {
//            print("Failed to update: \(error)")
//        }
//    }
//
//    func deleteEmployee(employee: Employee) {
//        let context = persistentContainer.viewContext
//        context.delete(employee)
//
//        do {
//            try context.save()
//        } catch let error {
//            print("Failed to delete: \(error)")
//        }
//    }

}
