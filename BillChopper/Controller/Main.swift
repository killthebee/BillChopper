import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    private var viewContext: NSManagedObjectContext!
    
    private lazy var profileViewController = ProfileViewController()
    private lazy var addEventViewController = AddEventViewController()
    private lazy var addSpendViewController = AddSpendViewController()
    
    private let eventButton = TopMainButton(color: UIColor.systemGray, title: R.string.main.eventButtonText())

    private let balanceButton = TopMainButton(color: customGreen, title: R.string.main.balanceButtonText())
    
    private let profileIcon = ProfileIcon(profileImage: R.image.hombreDefault1())

    private let footer = FooterView()
    
    private let coverPlusIconView: UIButton = {
        let coverView = UIButton()
        coverView.asCircle()
        coverView.showsMenuAsPrimaryAction = true
        
        return coverView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(SpendTableViewCell.self, forCellReuseIdentifier: SpendTableViewCell.identifier)
        tableView.register(LentCell.self, forCellReuseIdentifier: LentCell.newIdentifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        addSubviews()
    }
    
    private func setupViews() {
        viewContext = PersistanceController.shared.container.viewContext
        
        tableView.dataSource = self
        tableView.delegate = self
        
        eventButton.menu = getEventMenu()
        balanceButton.menu = getBalanceMenu()
        coverPlusIconView.menu = getCoverPlusIconMenu()
        
        let tapOnProfileIconGesutre = UITapGestureRecognizer(
            target: self, action: #selector(handleTapOnProfileIcon(sender:))
        )
        profileIcon.addGestureRecognizer(tapOnProfileIconGesutre)
    }
    
    private func addSubviews() {
        view.addSubview(profileIcon)
        view.addSubview(tableView)
        view.addSubview(eventButton)
        view.addSubview(balanceButton)
        view.addSubview(footer)
        view.addSubview(coverPlusIconView)
    }
    
    private func getEventMenu() -> UIMenu {
        let dummyEvent1 = UIAction(title: "event1", image: UIImage(named: "LentActionIcon")) { (action) in
            print("dummy event1")
        }
        let dummyEvent2 = UIAction(title: "event2", image: UIImage(named: "BorrowActionIcon")) { (action) in
            print("dummy event2")
        }
        
        let menu = UIMenu(
            title: R.string.main.eventMenuText(),
            options: .displayInline,
            children: [dummyEvent1, dummyEvent2]
        )
        
        return menu
    }
    
    private func getBalanceMenu() -> UIMenu {
        let dummyBalance1 = UIAction(title: "balance1", image: UIImage(named: "HombreDefault1.1")) { (action) in
            print("dummy balance1")
        }
        let dummyBalance2 = UIAction(title: "balance2", image: UIImage(named: "HombreDefault1.1")) { (action) in
            print("dummy balance2")
        }
        
        let menu = UIMenu(
            title: R.string.main.getBalanceMenuText(),
            options: .displayInline,
            children: [dummyBalance1, dummyBalance2]
        )
        
        return menu
    }
    
    private func getCoverPlusIconMenu() -> UIMenu {
        let addEvent = UIAction(title: "add new event", image: UIImage(named: "eventIcon")) { (action) in
            self.addEventViewController.modalPresentationStyle = .pageSheet
            self.addEventViewController.modalTransitionStyle = .coverVertical
            self.present(self.addEventViewController, animated: true)
        }
        let addSpend = UIAction(title: "add new spend", image: UIImage(named: "spendIcon")) { (action) in
            self.addSpendViewController.modalPresentationStyle = .pageSheet
            self.addSpendViewController.modalTransitionStyle = .coverVertical
            self.present(self.addSpendViewController, animated: true)
        }
        
        let menu = UIMenu(
            options: .displayInline,
            children: [addEvent, addSpend]
        )
        
        return menu
    }
    
    override func viewDidLayoutSubviews() {
        tableView.frame = CGRect(
            x: view.frame.size.width * 0.05,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.9,
            height: view.frame.size.height * 0.7
        )
        eventButton.frame = CGRect(
            x: view.frame.size.height * 0.03,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.04
        )
        balanceButton.frame = CGRect(
            x: view.frame.size.height * 0.21,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.04
        )
        profileIcon.frame = CGRect(
            x: view.frame.size.height * 0.4,
            y: view.frame.size.width * 0.3,
            width: view.frame.size.height * 0.04,
            height: view.frame.size.height * 0.04
        )
        footer.frame = CGRect(
            x: 0,
            y: view.frame.size.height * 0.85,
            width: view.frame.size.width,
            height: view.frame.size.height * 0.15
        )
        coverPlusIconView.frame = CGRect(
            x: view.frame.size.width * 0.4,
            y: view.frame.size.height * 0.8,
            width: view.frame.size.width * 0.2,
            height: view.frame.size.width * 0.2
        )
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


extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return SpendTableViewCell.cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            return UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
            return 13
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        
        if indexPath.section != 3 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendTableViewCell.identifier) as? SpendTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .white
            cell.selectedBackgroundView = backgroundView
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: LentCell.newIdentifier) as? LentCell else { return UITableViewCell() }
            cell.backgroundColor = .white
            cell.selectedBackgroundView = backgroundView
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.09
    }
    
}
