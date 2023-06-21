import UIKit
import CoreData

final class MainViewController: UIViewController {
    
    // TODO: perform fetch current user and set current user in app with right data type
    // TODO: balance for empty user!
    var appUser: AppUser? = nil
    
    // TODO: Probably it'll be best to make sets, if it's possible to make 'em hashable
    private var eventButtonData: [EventButtonDataProtocol] = [] {
        didSet {
            self.eventButton.menu = getEventMenu()
        }
    }
    
    private var usersButtonData: [UsersButtonDataProtocol] = [] {
        didSet {
            self.balanceButton.menu = getBalanceMenu()
        }
    }
    
    private var spendsData: [SpendDataProtocol] = []
    
    // unowned??
    private lazy var profileViewController = ProfileViewController()
    private lazy var addEventViewController = AddEventViewController()
    private lazy var addSpendViewController = AddSpendViewController()
    
    // TODO: make buttons area shorter
    private let eventButton = TopMainButton(color: UIColor.systemGray, title: R.string.main.eventButtonText())

    private let balanceButton = TopMainButton(color: customGreen, title: R.string.main.balanceButtonText())
    
    private let profileIcon = ProfileIcon(profileImage: R.image.hombreDefault1())

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
        var request = setupRequest(url: .fetchEventsSpends, method: .get)
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else {
            // it'll probably be present
            return
        }
         request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        let successHanlder = { [unowned self] (data: Data) throws in
            var eventsData: [EventButtonData] = []
            var participants: [UsersButtonData] = []
            var spendsData: [SpendDataProtocol] = []
            guard let appUserPhone = self.appUser?.phone else { return }
            let responseObject = try JSONDecoder().decode([EventsSpends].self, from: data)
            for event in responseObject {
                let eventButtonData = EventButtonData(
                    id: event.id,
                    name: event.name,
                    eventType: event.event_type
                )
                eventsData.append(eventButtonData)
                // TODO: perform save users to db
                for participant in event.participants {
                    let newBalanceWithUser = UsersButtonData(
                        username: participant.first_name, imageName: "HombreDefault1"
                    )
                    participants.append(newBalanceWithUser)
                }
                
                for spend in event.spends {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "YYYY-MM-dd"
                    guard let date = dateFormatter.date(from: spend.date) else {
                        return
                    }
                    if spend.payeer.username == appUserPhone {
                        let percent = 100 - (spend.split[appUserPhone] ?? 0)
                        // wtf is this amount?!
                        spendsData.append(SpendData(
                            spendName: spend.name,
                            payeerName: appUserPhone,
                            amount: Int16(Float(spend.amount) * ((Float(percent) / Float(100)))),
                            isBorrowed: false,
                            totalAmount: spend.amount,
                            date: date
                        ))
                        continue
                    }
                    spendsData.append(SpendData(
                        spendName: spend.name,
                        payeerName: spend.payeer.first_name,
                        amount: spend.amount * Int16(spend.split[appUserPhone] ?? 0) / 100,
                        isBorrowed: true,
                        totalAmount: spend.amount,
                        date: date
                    ))
                }
            }
            DispatchQueue.main.async {
                self.eventButtonData = eventsData
                self.usersButtonData = participants
                
                self.spendsData = spendsData
                self.tableView.reloadData()
                
                let total = self.calculateTotal()
                self.footer.balance.text = "\(total) usd"
                if total > 0 {
                    self.footer.balanceTypeLabel.text = R.string.mainCell.youLent()
                    self.footer.balanceTypeLabel.textColor = customGreen
                    self.footer.balance.textColor = customGreen
                } else {
                    self.footer.balanceTypeLabel.text = R.string.mainCell.youBorrowed()
                    self.footer.balanceTypeLabel.textColor = .red
                    self.footer.balance.textColor = .red
                }
            }
        }
        // TODO: make a failure handler!
        performRequest(request: request, successHandler: successHanlder)
        view.backgroundColor = .white
        setupViews()
        addSubviews()
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
            let eventName = eventData.name
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
            let eventButton = UIAction(title: usersData.username, image: UIImage(named: usersData.imageName)) { (action) in
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
    
    private func calculateTotal() -> Int16 {
        var total: Int16 = 0
        for spendData in spendsData {
            if spendData.isBorrowed {
                total -= spendData.amount
                continue
            }
            total += spendData.amount
        }
        
        return total
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
