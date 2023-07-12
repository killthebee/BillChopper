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
    
    func updateAppUser(newPhone: String?, newUsername: String?, isMale: Bool) {
        persistentContainer.performBackgroundTask{ (context) in
            do {
                let fetchRequest = NSFetchRequest<AppUser>(entityName: "AppUser")
                fetchRequest.fetchLimit = 1
                let currentUser = try context.fetch(fetchRequest).first
                currentUser?.username = newUsername
                currentUser?.phone = newPhone
                currentUser?.isMale = isMale
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
                participantData.addToEvents(eventData)
                
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
                payeer.addToSpends(spendData)
                spendData.event = eventData
                eventData.addToSpends(spendData)
                
                for (phone, percent) in spend.split{
                    guard let participant = participantsTempStorage[phone] else {
                        continue
                    }
                    let splitUnitData = SplitUnit(context: context)
                    splitUnitData.percent = Int16(percent)
                    splitUnitData.participant = participant
                    participant.addToSplitUnits(splitUnitData)
                    splitUnitData.spend = spendData
                    spendData.addToSplitUnits(splitUnitData)
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
    
    func fetchSpends() -> [Spend]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Spend>(entityName: "Spend")
        
        do {
            let spends = try context.fetch(fetchRequest)
            return spends
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        return nil
    }
    
    func fetchParticipants() -> [Participant]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Participant>(entityName: "Participant")
        
        do {
            let participants = try context.fetch(fetchRequest)
            return participants
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        return nil
    }
    
    func fetchEvents() -> [Event]? {
        let context = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Event>(entityName: "Event")
//        fetchRequest.relationshipKeyPathsForPrefetching = ["spends"]
//        fetchRequest.returnsObjectsAsFaults = true
        do {
            let events = try context.fetch(fetchRequest)
            return events
        } catch let error {
            print("Failed to fetch: \(error)")
        }
        return nil
    }
    
    func fetchEventSpends(_ event: Event) -> [Spend] {
        let context = persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<Spend>(entityName: "Spend")
        fetchRequest.predicate = NSPredicate(format: "event == %@", event)
        
        do {
            let spends = try context.fetch(fetchRequest)
            return spends
        } catch let error {
            print("Failed to fetch spends for event: \(error)")
        }
        return []
    }
    
    func fetchBalanceWithUser(appUser: Participant, targetUser: Participant) -> (Set<Spend>, Int32)? {
        let context = persistentContainer.viewContext
        var relatedSpends = Set<Spend>()
        
        let fetchRequestLent = NSFetchRequest<SplitUnit>(entityName: "SplitUnit")
        let payedByAppUserPredicate = NSPredicate(format: "spend.payeer == %@", appUser)
        let targetUserParticipatedPredicate = NSPredicate(
            format: "participant == %@", targetUser
        )
        var lentPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                payedByAppUserPredicate, targetUserParticipatedPredicate
            ]
        )
        fetchRequestLent.relationshipKeyPathsForPrefetching = ["spend"]
        fetchRequestLent.predicate = lentPredicate
        let lentSplitUnits: [SplitUnit]!
        do {
            lentSplitUnits = try context.fetch(fetchRequestLent)
        } catch let error {
            print("Failed to fetch lent split units: \(error)")
            return nil
        }
        
        var totalCount: Float = 0
        lentSplitUnits.forEach({
            guard let spend = $0.spend else { return }
            totalCount += (Float(spend.totalAmount) * Float($0.percent)) / 100
            relatedSpends.insert(spend)
        })
        
        let fetchRequestBorrow = NSFetchRequest<SplitUnit>(entityName: "SplitUnit")
        let payedByTargetUserPredicate = NSPredicate(format: "spend.payeer == %@", targetUser)
        let appUserParPredicate = NSPredicate(format: "participant == %@", appUser)
        let borrowPredicate = NSCompoundPredicate(
            andPredicateWithSubpredicates: [
                payedByTargetUserPredicate, appUserParPredicate
            ]
        )
        
        fetchRequestBorrow.relationshipKeyPathsForPrefetching = ["spend"]
        fetchRequestBorrow.predicate = borrowPredicate
        let borrowSpliUnits: [SplitUnit]!
        do {
            borrowSpliUnits = try context.fetch(fetchRequestBorrow)
        } catch let error {
            print("Failed to fetch borrow split units: \(error)")
            return nil
        }
        
        borrowSpliUnits.forEach({
            guard let spend = $0.spend else { return }
            totalCount -= (Float(spend.totalAmount) * Float($0.percent)) / 100
            relatedSpends.insert(spend)
        })
        
        return (relatedSpends, Int32(totalCount))
    }
    
    func clearAppData() {
        let context = persistentContainer.viewContext
        
        var fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "SplitUnit")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("fieled to delete split units: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Spend")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("fieled to delete spends: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Event")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("fieled to delete participants: \(error)")
        }
        
        fetchRequest = NSFetchRequest(entityName: "Participant")
        deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("fieled to delete participants: \(error)")
        }
    }
    
    func clearAppUser() {
        let context = persistentContainer.viewContext
        
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "AppUser")
        var deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try persistentContainer.persistentStoreCoordinator.execute(deleteRequest, with: context)
        } catch let error as NSError {
            print("fieled to delete app user: \(error)")
        }
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
