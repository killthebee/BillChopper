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
        let frameX = screenRect.size.width * 0.05
        let frameWidth = screenRect.size.width - screenRect.size.width * 0.1
        let frameHeight = screenRect.size.height - 3 * tenthOfWindowHeight
        
        let frame = CGRect(
            x: frameX,
            y: frameY,
            width: frameWidth,
            height: frameHeight
        )
        let tableView = UITableView(frame: frame)
        
        tableView.register(SpendTableViewCell.self, forCellReuseIdentifier: SpendTableViewCell.identifier)
        tableView.register(LentCell.self, forCellReuseIdentifier: LentCell.newIdentifier)
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SpendTableViewCell.cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView()
            headerView.backgroundColor = UIColor.clear
            return headerView
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
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return self.testData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section != 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendTableViewCell.identifier) as? SpendTableViewCell else { return UITableViewCell() }
            return cell 
        }
        else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LentCell.newIdentifier) as? LentCell else { return UITableViewCell() }
            print("here here")
            return cell
        }
    }
}


extension Main: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print(testData[indexPath.row])
    }
}
