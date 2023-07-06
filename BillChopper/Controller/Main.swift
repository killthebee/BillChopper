import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    // TODO: perform fetch current user and set current user in app with right data type
    // TODO: balance for empty user!
    // TODO: Add "all" to events
    var appUser: AppUser? = nil
    
    // TODO: Probably it'll be best to make sets, if it's possible to make 'em hashable
    private var eventButtonData: [Event] = [] {
        didSet {
            self.eventButton.menu = getEventMenu()
        }
    }
    
    private var usersButtonData: [Participant] = [] {
        didSet {
            self.balanceButton.menu = getBalanceMenu()
        }
    }
    
    private var spendsData: [Spend] = []
    
    // unowned??
    private lazy var profileViewController = ProfileViewController()
    private lazy var addEventViewController = AddEventViewController()
    private lazy var addSpendViewController = AddSpendViewController()
    
    // TODO: make buttons area shorter
    private let eventButton = TopMainButton(color: UIColor.systemGray, title: R.string.main.eventButtonText())

    private let balanceButton = TopMainButton(color: customGreen, title: R.string.main.balanceButtonText())
    
    private let profileIcon: ProfileIcon = {
        if let appUserImage = loadImageFromDiskWith(fileName: "appUser") {
            return ProfileIcon(profileImage: appUserImage)
        }
        return ProfileIcon(profileImage: R.image.hombreDefault1())
    }()

    private let footer = FooterView()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(SpendTableViewCell.self, forCellReuseIdentifier: SpendTableViewCell.identifier)
        tableView.register(LentCell.self, forCellReuseIdentifier: LentCell.newIdentifier)
        
        return tableView
    }()
    
    let coverPlusIconView: UIButton = {
        let coverView = UIButton()
        coverView.showsMenuAsPrimaryAction = true
        return coverView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventButtonData = CoreDataManager.shared.fetchEvents() ?? []
        usersButtonData = CoreDataManager.shared.fetchParticipants() ?? []
        spendsData = CoreDataManager.shared.fetchSpends() ?? []
//        print(event)
//        let participantsSet = event?.spends
//        print(participantsSet)
//        let participants = participantsSet?.allObjects as? [Spend]
            
//        print(participants)
        view.backgroundColor = .white
        setupViews()
        addSubviews()
        calculateTotal()
    }
    
    private func setupViews() {
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
        [topContainerView, tableView, footer, coverPlusIconView
        ].forEach({view.addSubview($0)})
        [eventButton, balanceButton, iconContainerView].forEach({topContainerView.addSubview($0)})
        iconContainerView.addSubview(profileIcon)
    }
    
    private func getEventMenu() -> UIMenu {
        var buttons: [UIAction] = []
        for eventData in eventButtonData {
            let eventName = eventData.name ?? "unnamed"
            let imageName = reverseConvertEventTypes(type: eventData.eventType)
            let eventButton = UIAction(title: eventName, image: UIImage(named: imageName)) { (action) in
                print("event named: \(eventName)")
            }
            buttons.append(eventButton)
        }
        
        let menu = UIMenu(
            title: R.string.main.eventMenuText(),
            options: .displayInline,
            children: buttons
        )
        
        return menu
    }
    
    private func getBalanceMenu() -> UIMenu {
        var buttons: [UIAction] = []
        for usersData in usersButtonData {
            let username = usersData.username ?? "unnamed"
            let imageName = usersData.imageName ?? "HombreDefault1"
            print(imageName)
            let eventButton = UIAction(title: username, image: UIImage(named: imageName)) { (action) in
                print("event named: \(usersData.username)")
            }
            buttons.append(eventButton)
        }
        
        let menu = UIMenu(
            title: R.string.main.getBalanceMenuText(),
            options: .displayInline,
            children: buttons
        )
        
        return menu
    }
    
    private func calculateTotal() {
        var total: Int16 = 0
        for spendData in spendsData {
            if spendData.isBorrowed {
                total -= spendData.amount
                continue
            }
            total += spendData.amount
        }
        if total >= 0 {
            footer.balanceTypeLabel.text = R.string.mainCell.youLent()
            footer.balanceTypeLabel.textColor = customGreen
            footer.balance.text = String(total)
            footer.balance.textColor = customGreen
            return
        }
        footer.balanceTypeLabel.text = R.string.mainCell.youBorrowed()
        footer.balanceTypeLabel.textColor = .red
        footer.balance.text = String(total)
        footer.balance.textColor = .red
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
    
    private let topContainerView = UIView()
    private let iconContainerView = UIView()
    
    override func viewDidLayoutSubviews() {
        [topContainerView, eventButton, balanceButton, profileIcon, iconContainerView, footer, tableView,
         coverPlusIconView].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let  constraints: [NSLayoutConstraint] = [
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            topContainerView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            topContainerView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            topContainerView.heightAnchor.constraint(equalToConstant: 30),
            
            eventButton.widthAnchor.constraint(equalTo: topContainerView.widthAnchor, multiplier: 0.42),
            eventButton.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            eventButton.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            eventButton.heightAnchor.constraint(equalTo: topContainerView.heightAnchor),
            
            balanceButton.widthAnchor.constraint(equalTo: topContainerView.widthAnchor, multiplier: 0.42),
            balanceButton.heightAnchor.constraint(equalTo: eventButton.heightAnchor),
            balanceButton.leadingAnchor.constraint(equalTo: eventButton.trailingAnchor, constant: 10),
            
            iconContainerView.leadingAnchor.constraint(equalTo: balanceButton.trailingAnchor),
            iconContainerView.heightAnchor.constraint(equalTo: topContainerView.heightAnchor),
            iconContainerView.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            
            
            profileIcon.widthAnchor.constraint(equalToConstant: 30),
            profileIcon.heightAnchor.constraint(equalToConstant: 30),
            profileIcon.centerXAnchor.constraint(equalTo: iconContainerView.centerXAnchor),
            profileIcon.centerYAnchor.constraint(equalTo: iconContainerView.centerYAnchor),
            
            footer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2),
            footer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            footer.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            tableView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 50),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 5),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -5),
            tableView.bottomAnchor.constraint(equalTo: footer.topAnchor, constant: 20),
            
            coverPlusIconView.centerXAnchor.constraint(equalTo: footer.centerXAnchor),
            coverPlusIconView.centerYAnchor.constraint(equalTo: footer.topAnchor),
            coverPlusIconView.widthAnchor.constraint(equalToConstant: 100),
            coverPlusIconView.heightAnchor.constraint(equalToConstant: 100),
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    @objc func handleTapOnProfileIcon(sender: UITapGestureRecognizer) {
        // NOTE: https://developer.apple.com/documentation/uikit/uiviewcontroller/1621505-dismiss
        profileViewController.modalPresentationStyle = .pageSheet
        profileViewController.appUser = self.appUser
        profileViewController.isImageChanged = false
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
        return spendsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // do I even need background color?
        let cellData = spendsData[indexPath.section]
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        
        if cellData.isBorrowed {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SpendTableViewCell.identifier) as? SpendTableViewCell else { return UITableViewCell() }
            cell.backgroundColor = .white
            cell.selectedBackgroundView = backgroundView
            
            cell.configure(cellData)
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LentCell.newIdentifier) as? LentCell else { return UITableViewCell() }
        cell.backgroundColor = .white
        cell.selectedBackgroundView = backgroundView
        cell.configure(cellData)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
