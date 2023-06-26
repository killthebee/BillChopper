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
        fetchRequest.fetchLimit = 1

        do {
            let appUser = try context.fetch(fetchRequest)
            if appUser.count != 1 { return nil }
            return appUser.first
        } catch let error {
            print("Failed to fetch companies: \(error)")
        }

        return nil
    }
    
    func updateAppUser(user: AppUser) {
        let context = persistentContainer.viewContext
        
        persistentContainer.performBackgroundTask{ (context) in
            do {
                try context.save()
            } catch let error {
                print("Failed to update: \(error)")
            }
        }
   }
    
    func saveEventsSpends(data: [EventsSpends], appUserPhone: String) {
        let context = persistentContainer.viewContext
        
        // TODO: check if it's on main thread ones I'll figure out where to fire this method
        // I'll keep participants in memory for a monent
        var participantsTempStorage: [String: Participant] = [:]
        for event in data{
            let eventData = Event(context: context)
            eventData.id = event.id
            eventData.eventType = Int16(event.event_type)
            eventData.name = event.name
            for participant in event.participants {
                if let existingParticipant = participantsTempStorage[participant.username] {
                    eventData.addToParticipants(existingParticipant)
                    continue
                }
                let participantData = Participant(context: context)
                participantData.imageName = participant.username
                participantData.imageUrl = participant.profile.profile_image
                participantData.username = participant.first_name
                
                eventData.addToParticipants(participantData)
                participantsTempStorage[participant.username] = participantData
            }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "YYYY-MM-dd"
            for spend in event.spends {
                let spendData = Spend(context: context)
                guard let date = dateFormatter.date(from: spend.date),
                      let payeer = participantsTempStorage[spend.payeer.username] else {
                    continue
                }
                let isBorrowed = spend.payeer.username != appUserPhone
                spendData.amount = calculateSpendAmount(
                    isBorrowed: isBorrowed,
                    spend.amount,
                    spend.split,
                    phone: appUserPhone
                )
                spendData.totalAmount = spend.amount
                spendData.name = spend.name
                spendData.isBorrowed = isBorrowed
                spendData.date = date
                spendData.payeer = payeer
                
                for (phone, percent) in spend.split{
                    guard let participant = participantsTempStorage[phone] else {
                        continue
                    }
                    let spendUnitData = SplitUnit(context: context)
                    spendUnitData.percent = Int16(percent)
                    spendUnitData.participant = participant
                    spendUnitData.spend = spendData
                }
            }
                
            do {
                try context.save()
            } catch let error {
                print("Failed to fill db: \(error)")
            }
        }
        
    }
    
    func fetchSplitUnits() -> [SplitUnit]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<SplitUnit>(entityName: "SplitUnit")
        
        do {
            let units = try context.fetch(fetchRequest)
            return units
        } catch let error {
            print("Failed to fetch: \(error)")
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
//
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
