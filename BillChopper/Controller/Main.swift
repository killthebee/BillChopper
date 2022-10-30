import UIKit
import CoreData


class Main: UIViewController {
    
    var viewController = PersistanceController.shared
    var viewContext: NSManagedObjectContext!
    let testData: [String] = ["1", "2", "3", "4" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8"]
    
    let screenRect = UIScreen.main.bounds
    let tenthOfWindowHeight = UIScreen.main.bounds.size.height / 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewContext = viewController.container.viewContext
        let tableView = setUpTableView()
        let eventButton = setUpEventButton()
        let balanceButton = setUpBalanceButton()
        let profileIcon = setUpProfileIcon()
        
        view.addSubview(profileIcon)
        view.addSubview(tableView)
        view.addSubview(eventButton)
        view.addSubview(balanceButton)
    }
    
    override func loadView() {
        super.loadView()
    }
    
    private func setUpEventButton() -> UIButton {
        let frame = CGRect(
            x: tenthOfWindowHeight * 0.3,
            y: screenRect.size.width * 0.3,
            width: screenRect.size.width * 0.35,
            height: tenthOfWindowHeight * 0.4
        )
        let eventButton = UIButton(frame: frame)
        
        eventButton.backgroundColor = UIColor.systemGray
        eventButton.layer.cornerRadius = 15
        eventButton.clipsToBounds = true
        eventButton.setTitle("event: All", for: .normal )
        
        let menu = getEventMenu()
        eventButton.menu = menu
        eventButton.showsMenuAsPrimaryAction = true
        
        return eventButton
    }
    
    private func getEventMenu() -> UIMenu {
        let dummyEvent1 = UIAction(title: "event1", image: UIImage(named: "LentActionIcon")) {
            (action) in
            print("dummy event1")
        }
        let dummyEvent2 = UIAction(title: "event2", image: UIImage(named: "BorrowActionIcon")) {
            (action) in
            print("dummy event2")
        }
        
        let menu = UIMenu(
            title: "events",
            options: .displayInline,
            children: [dummyEvent1, dummyEvent2]
        )
        
        return menu
    }
    
    private func setUpBalanceButton() -> UIButton{
        let frame = CGRect(
            x: tenthOfWindowHeight * 2.1,
            y: screenRect.size.width * 0.3,
            width: screenRect.size.width * 0.35,
            height: tenthOfWindowHeight * 0.4
        )
        
        let balanceButton = UIButton(frame: frame)
        
        balanceButton.backgroundColor = UIColor.systemGreen
        balanceButton.layer.cornerRadius = 15
        balanceButton.clipsToBounds = true
        balanceButton.titleLabel?.text = "tak bleat"
        
        return balanceButton
    }
    
    private func setUpTableView() -> UITableView {
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
    
    private func setUpProfileIcon() -> UIView {
        let profileIcon = ProfileIcon()
        profileIcon.image = UIImage(named: "HombreDefault1")
        
        let frame = CGRect(
            x: tenthOfWindowHeight * 4.0,
            y: screenRect.size.width * 0.3,
            width: tenthOfWindowHeight * 0.4,
            height: tenthOfWindowHeight * 0.4
        )
        
        profileIcon.frame = frame
        return profileIcon
    }
    
    private func setUpProfileLable() -> UILabel {
        //let profileLableCover = UIView()
        let profileLable = UILabel()
        
        //profileLable.center = self.view.center
        profileLable.text = "me"
        profileLable.textAlignment = .center
        profileLable.textColor = .black
        
        
//        profileLableCover.backgroundColor = .lightGray
//        profileLableCover.frame = CGRect(
//            x: tenthOfWindowHeight * 3.95,
//            y: screenRect.size.width * 0.37,
//            width: tenthOfWindowHeight * 0.5,
//            height: tenthOfWindowHeight * 0.20
//        )
        profileLable.frame = CGRect(
            x: tenthOfWindowHeight * 3.95,
            y: screenRect.size.width * 0.37,
            width: tenthOfWindowHeight * 0.5,
            height: tenthOfWindowHeight * 0.20
        )
        
        //profileLableCover.addSubview(profileLable)
        return profileLable
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


//extension UILabel {
//    func centerVertically() {
//        let fittingSize = CGSize(width: bounds.width, height: CGFloat.greatestFiniteMagnitude)
//        let size = sizeThatFits(fittingSize)
//        let topOffset = (bounds.size.height - size.height * zoomScale) / 2
//        let positiveTopOffset = max(1, topOffset)
//        contentOffset.y = -positiveTopOffset
//    }
//}
