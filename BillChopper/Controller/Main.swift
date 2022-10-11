import UIKit
import CoreData


class Main: UIViewController {
    
    var viewController = PersistanceController.shared
    var viewContext: NSManagedObjectContext!
    var nameField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = viewController.container.viewContext

//        guard container != nil else {
//            fatalError("Failed to connect to Persisten Container")
//        }
    }
    
    override func loadView() {
        super.loadView()
        var lel = UILabel(frame: CGRect(x: 50, y: 200, width: 200, height: 50))
        lel.text = "hmmm"
        view.addSubview(lel)
        
        nameField = UITextField(frame: CGRect(x: 300, y: 500, width: 200, height: 50))
        nameField.placeholder = "name>"
        var saveButton = UIButton(frame: CGRect(x: 100, y: 700, width: 100, height: 50))
        saveButton.setTitle("save", for: .normal)
        saveButton.backgroundColor = .orange
        saveButton.addTarget(nil, action: #selector(saveStuff(_:)), for: .touchUpInside)
        let fetchButton = UIButton(frame: CGRect(x: 100, y: 600, width: 100, height: 50))
        fetchButton.backgroundColor = .orange
        fetchButton.addTarget(nil, action: #selector(fetchStuff(_:)), for: .touchUpInside)
        
        let eventButton = UIButton(frame: CGRect(x: 100, y: 500, width: 100, height: 50))
        eventButton.setTitle("EVENT", for: .normal)
        eventButton.backgroundColor = .orange
        eventButton.addTarget(nil, action: #selector(eventStuff(_:)), for: .touchUpInside)
        
        view.addSubview(saveButton)
        view.addSubview(eventButton)
        view.addSubview(fetchButton)
        view.addSubview(nameField)
    }
    
    @objc func saveStuff(_ sender: UIButton!) {
        let text = nameField.text
        //AppUser.create(name: text!, context: viewContext)
    }
    
    @objc func eventStuff(_ sender: UIButton!) {
        let text = nameField.text
        //Event.create(name: text!, context: viewContext)
    }
    
    @objc func fetchStuff(_ sender: UIButton) {
        let request = AppUser.createFetchRequest()
        do {
            let appUsers = try viewContext.fetch(request)
            print(appUsers.count)
            print(appUsers[0].name)
        } catch {
            print("fetch failed")
        }
        //print(hmm.wrappedValue)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


//extension AppUser {
//    @NSManaged public var name: String
//    @NSManaged public var code: Int16
//    @NSManaged public var phone: String
//
//    static func create(
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
//}
