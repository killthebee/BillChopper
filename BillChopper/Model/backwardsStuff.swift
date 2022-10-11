//static func create(
//        name: String,
//        code: Int16 = 1,
//        phone: String = "88005553535",
//        context manageObjectConext: NSManagedObjectContext
//    ) {
//        let user1 = AppUser(context: manageObjectConext)
//        user1.name = name
//        user1.code = 1
//        user1.phone = "88005553535"
//        do {
//            try manageObjectConext.save()
//        } catch {
//            let nserror = error as NSError
//            fatalError("Unresolved error: \(nserror), \(nserror.userInfo)")
//        }
//    }
