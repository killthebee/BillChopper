import UIKit
import CoreData


class Main: UIViewController {
    
    var viewController = PersistanceController.shared
    var viewContext: NSManagedObjectContext!
    let testData: [String] = ["1", "2", "3", "4" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = viewController.container.viewContext
        let tableView = setUpTableView()
        
        view.addSubview(tableView)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    private func setUpTableView() -> UITableView {
        let screenRect = UIScreen.main.bounds
        let tenthOfWindowHeight = screenRect.size.height / 10
        let frameY = 2 * tenthOfWindowHeight
        let frameHeight = screenRect.size.height - 3 * tenthOfWindowHeight
        
        let frame = CGRect(
            x: 0,
            y: frameY,
            width: screenRect.size.width,
            height: frameHeight
        )
        let tableView = UITableView(frame: frame)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "testCells")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
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
    }
}


extension Main: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "testCells")! as UITableViewCell
        cell.textLabel?.text = self.testData[indexPath.row]
        return cell
    }
}


extension Main: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(testData[indexPath.row])
    }
}
