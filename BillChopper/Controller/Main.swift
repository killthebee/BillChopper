import UIKit
import CoreData


// TODO: Make table a bit higher
// TODO: put a logo above buttons


class Main: UIViewController {
    
    var viewController = PersistanceController.shared
    var viewContext: NSManagedObjectContext!
    let testData: [String] = ["1", "2", "3", "4" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8" , "5", "6", "7", "8"]
    
    lazy var profileViewController = ProfileViewController()
    lazy var addEventViewController = AddEventViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        viewContext = viewController.container.viewContext
        let tableView = setUpTableView()
        let eventButton = setUpEventButton()
        let balanceButton = setUpBalanceButton()
        let profileIcon = setUpProfileIcon()
        let footer = setUpFooterView()
        let coverPlusIconView = setUpCoverPlusIconView()
        
        let tapOnProfileIconGesutre = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnProfileIcon(sender:))
        )
        profileIcon.addGestureRecognizer(tapOnProfileIconGesutre)
        
        view.addSubview(profileIcon)
        view.addSubview(tableView)
        view.addSubview(eventButton)
        view.addSubview(balanceButton)
        
        view.addSubview(footer)
        view.addSubview(coverPlusIconView)
        //view.addSubview(EditUSerView())
    }
    
    override func loadView() {
        super.loadView()
    }
    
    private func setUpEventButton() -> UIButton {
        let frame = CGRect(
            x: view.frame.size.height * 0.03,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.04
        )
        let eventButton = UIButton(frame: frame)
        
        eventButton.backgroundColor = UIColor.systemGray
        eventButton.layer.cornerRadius = 15
        eventButton.clipsToBounds = true
        eventButton.setTitle("event:", for: .normal )
        
        eventButton.menu = getEventMenu()
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
            x: view.frame.size.height * 0.21,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.04
        )
        
        let balanceButton = UIButton(frame: frame)
        
        balanceButton.backgroundColor = UIColor.systemGreen
        balanceButton.layer.cornerRadius = 15
        balanceButton.clipsToBounds = true
        balanceButton.setTitle("balance with:", for: .normal)
        
        balanceButton.menu = getBalanceMenu()
        balanceButton.showsMenuAsPrimaryAction = true
        
        return balanceButton
    }
    
    private func getBalanceMenu() -> UIMenu {
        let dummyBalance1 = UIAction(title: "balance1", image: UIImage(named: "HombreDefault1.1")) {
            (action) in
            print("dummy balance1")
        }
        let dummyBalance2 = UIAction(title: "balance2", image: UIImage(named: "HombreDefault1.1")) {
            (action) in
            print("dummy balance2")
        }
        
        let menu = UIMenu(
            title: "users",
            options: .displayInline,
            children: [dummyBalance1, dummyBalance2]
        )
        
        return menu
    }
    
    private func setUpTableView() -> UITableView {
        let frame = CGRect(
            x: view.frame.size.width * 0.05,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.9,
            height: view.frame.size.height * 0.7
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
        // it's a placeholder!
        // Sorta dislike to include types into var names ( Is it ok? )
        profileIcon.image = UIImage(named: "HombreDefault1")
        
        let frame = CGRect(
            x: view.frame.size.height * 0.4,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.height * 0.04,
            height: view.frame.size.height * 0.04
        )
        
        profileIcon.frame = frame
        return profileIcon
    }
    
    private func setUpProfileLable() -> UILabel {
        let profileLable = UILabel()
        
        profileLable.text = "me"
        profileLable.textAlignment = .center
        profileLable.textColor = .black
        
        profileLable.frame = CGRect(
            x: view.frame.size.height * 0.395,
            y: view.frame.size.width * 0.37,
            width: view.frame.size.height * 0.05,
            height: view.frame.size.height * 0.02
        )
        
        return profileLable
    }
    
    private func setUpFooterView() -> FooterView {
        let frame1 = CGRect(
            x: 0,
            y: view.frame.size.height * 0.85,
            width: view.frame.size.width,
            height: view.frame.size.height * 0.15
        )
        
        let footer = FooterView(frame: frame1)
        return footer
    }
    
    private func setUpCoverPlusIconView() -> UIButton {
        let coverView = UIButton()
        coverView.frame = CGRect(
            x: view.frame.size.width * 0.4,
            y: view.frame.size.height * 0.8,
            width: view.frame.size.width * 0.2,
            height: view.frame.size.width * 0.2
        )
        //coverView.backgroundColor = .red
        coverView.asCircle()
        
        coverView.menu = getCoverPlusIconMenu()
        coverView.showsMenuAsPrimaryAction = true
        
        return coverView
    }
    
    private func getCoverPlusIconMenu() -> UIMenu {
        // TODO: mb add icons
        let addEvent = UIAction(title: "add new event", image: UIImage(named: "eventIcon")) {
            (action) in
            self.addEventViewController.modalPresentationStyle = .pageSheet
            self.addEventViewController.modalTransitionStyle = .coverVertical
            self.present(self.addEventViewController, animated: true)
        }
        let addSpend = UIAction(title: "add new spend", image: UIImage(named: "spendIcon")) {
            (action) in
            print("dummy event2")
        }
        
        let menu = UIMenu(
            options: .displayInline,
            children: [addEvent, addSpend]
        )
        
        return menu
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
    
    @objc func handleTapOnProfileIcon(sender: UITapGestureRecognizer) {
        // NOTE: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss
        profileViewController.modalPresentationStyle = .pageSheet
        profileViewController.modalTransitionStyle = .coverVertical
        present(profileViewController, animated: true)
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
