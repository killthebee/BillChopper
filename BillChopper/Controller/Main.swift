import UIKit

final class MainViewController: UIViewController {
    
    // MARL: Data
    var appUser: AppUser? = nil
    var currentAppUser: Participant? = nil
    
    var eventButtonData: [Event] = [] {
        didSet {
            self.eventButton.menu = getEventMenu()
        }
    }
    
    private var usersButtonData: [Participant] = [] {
        didSet {
            self.balanceButton.menu = getBalanceMenu()
        }
    }
    
    var spendsData: [Spend] = []
    
    // MARK: UI Elements
    private let eventButton = TopMainButton(
        color: UIColor.systemGray, title: R.string.main.eventButtonText()
    )

    private let balanceButton = TopMainButton(
        color: customGreen, title: R.string.main.balanceButtonText()
    )
    
    let profileIcon: ProfileIcon = {
        if let appUserImage = loadImageFromDiskWith(fileName: "appUser") {
            return ProfileIcon(profileImage: appUserImage)
        }
        
        return ProfileIcon(profileImage: R.image.hombreDefault1())
    }()

    private let footer = FooterView()
    
    let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.register(
            SpendTableViewCell.self,
            forCellReuseIdentifier: SpendTableViewCell.identifier
        )
        tableView.register(
            LentCell.self,
            forCellReuseIdentifier: LentCell.newIdentifier
        )
        
        return tableView
    }()
    
    let coverPlusIconView: UIButton = {
        let coverView = UIButton()
        coverView.showsMenuAsPrimaryAction = true
        return coverView
    }()
    
    private func getCoverPlusIconMenu() -> UIMenu {
        let addEvent = UIAction(
            title: R.string.main.addEvent(),
            image: UIImage(named: "eventIcon")) { (action) in
            let AddEventViewController = AddEventViewController()
            AddEventViewController.mainVC = self
            AddEventViewController.currentUserPhone = self.currentAppUser?.imageName
            AddEventViewController.modalPresentationStyle = .pageSheet
            AddEventViewController.modalTransitionStyle = .coverVertical
            self.present(AddEventViewController, animated: true)
        }
        let addSpend = UIAction(
            title: R.string.main.addSpend(),
            image: UIImage(named: "spendIcon")) { (action) in
            let addSpendViewController = AddSpendViewController()
            addSpendViewController.mainVC = self
            addSpendViewController.events = self.eventButtonData
            addSpendViewController.modalPresentationStyle = .pageSheet
            addSpendViewController.modalTransitionStyle = .coverVertical
            self.present(addSpendViewController, animated: true)
        }
        
        let menu = UIMenu(
            options: .displayInline,
            children: [addEvent, addSpend]
        )
        
        return menu
    }
    
    private func getEventMenu() -> UIMenu {
        var buttons: [UIAction] = []
        addAllEventsButton(&buttons)
        for eventData in eventButtonData {
            addEventButton(&buttons, eventData)
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
            if usersData == currentAppUser { continue }
            buttons.append(makeUserButton(usersData))
        }
        
        let menu = UIMenu(
            title: R.string.main.getBalanceMenuText(),
            options: .displayInline,
            children: buttons
        )
        
        return menu
    }
    
    // MAKR: Setup VC
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        
        view.backgroundColor = .white
        setupViews()
        addSubviews()
        setNewTotal()
        downloadPhotos()
    }
    
    private func loadData() {
        eventButtonData = CoreDataManager.shared.fetchEvents() ?? []
        usersButtonData = CoreDataManager.shared.fetchParticipants() ?? []
        spendsData = CoreDataManager.shared.fetchSpends() ?? []
        usersButtonData.forEach({
            if $0.imageName == appUser?.phone {
                currentAppUser = $0
                currentAppUser?.username = R.string.main.you()
            }
        })
    }
    
    private func setupViews() {
        tableView.dataSource = self
        tableView.delegate = self
        
        eventButton.menu = getEventMenu()
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
    
    // MARK: Layout
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
    
    // MARK: Logic
    private func downloadPhotos() {
        DispatchQueue.global(qos: .utility).async {
            for particiapnt in self.usersButtonData {
                guard let imgUrl = particiapnt.imageUrl,
                      let imageName = particiapnt.imageName,
                      let imageData = downloadImage(url: imgUrl) else { continue }
                saveImage(fileName: imageName, image: UIImage(data: imageData)!)
            }
            DispatchQueue.main.async {
                self.balanceButton.menu = self.getBalanceMenu()
            }
        }
    }
    
    private func addAllEventsButton(_ buttons: inout [UIAction]) {
        let allEventsButton = UIAction(title: R.string.main.all()) { (action) in
            self.spendsData = CoreDataManager.shared.fetchSpends() ?? []
            self.tableView.reloadData()
            self.footer.eventName.text = R.string.main.allBig()
            self.footer.eventText.text = R.string.main.eventMenuText()
            self.setNewTotal()
        }
        buttons.append(allEventsButton)
    }
    
    private func addEventButton(_ buttons: inout [UIAction], _ eventData: Event) {
        let eventName = eventData.name ?? R.string.main.unnamed()
        let imageName = reverseConvertEventTypes(type: eventData.eventType)
        let eventButton = UIAction(title: eventName, image: UIImage(named: imageName)) { (action) in
            self.spendsData = CoreDataManager.shared.fetchEventSpends(eventData)
            self.tableView.reloadData()
            self.footer.eventName.text = eventName
            self.footer.eventText.text = R.string.main.singularEventText()
            self.setNewTotal()
        }
        buttons.append(eventButton)
    }
    
    private func serializeData(_ usersData: Participant) -> (
        username: String, imageName: UIImage?
    ) {
        let username = usersData.username ?? R.string.main.unnamed()
        let userImage: UIImage?!
        if let imageName = usersData.imageName {
            userImage = loadImageFromDiskWith(fileName: imageName)
        } else {
            userImage = R.image.hombreDefault1()
        }
        
        return (username, userImage)
    }
    
    private func setpupFooterForBalance(_ total: Int32) {
        self.footer.eventName.text = R.string.main.allBig()
        if total > 0 {
            self.footer.balanceTypeLabel.text = R.string.mainCell.youLent()
            self.footer.balance.text = String(total)
            self.footer.balance.textColor = customGreen
            self.footer.balanceTypeLabel.textColor = customGreen
        } else {
            self.footer.balanceTypeLabel.text = R.string.mainCell.youBorrowed()
            self.footer.balanceTypeLabel.textColor = .red
            self.footer.balance.text = String(-1 * total)
            self.footer.balance.textColor = .red
        }
    }
    
    private func makeUserButton(_ userData: Participant) -> UIAction {
        let (username, userImage) = serializeData(userData)
        let userButton = UIAction(title: username, image: userImage) { _ in
            guard let currentUser = self.currentAppUser else { return }
            guard let (spends, total) = CoreDataManager.shared.fetchBalanceWithUser(
                appUser: currentUser, targetUser: userData
            ) else { return }
            self.spendsData = []
            spends.forEach({self.spendsData.append($0)})
            self.tableView.reloadData()
            self.setpupFooterForBalance(total)
        }
        
        return userButton
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
    
    private func setNewTotal() {
        var total = calculateTotal()
        
        if total >= 0 {
            footer.balanceTypeLabel.text = R.string.mainCell.youLent()
            footer.balanceTypeLabel.textColor = customGreen
            footer.balance.text = String(total)
            footer.balance.textColor = customGreen
            return
        }
        footer.balanceTypeLabel.text = R.string.mainCell.youBorrowed()
        footer.balanceTypeLabel.textColor = .red
        footer.balance.text = String(-1 * total)
        footer.balance.textColor = .red
    }
    
    @objc func handleTapOnProfileIcon(sender: UITapGestureRecognizer) {
        let profileViewController = ProfileViewController()
        profileViewController.mainVC = self
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
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if let cell = tableView.cellForRow(at: indexPath) as? LentCell {
          return true
       } else {
          return false
       }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let payed = UIContextualAction(style: .destructive, title: R.string.main.payed()) {
            [weak self] (action, view, completionHandler) in
            self?.handleMoveToTrash(indexPath)
            completionHandler(true)
        }
        payed.backgroundColor = .systemRed

        let configuration = UISwipeActionsConfiguration(actions: [payed])

        return configuration
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    private func handleMoveToTrash(_ index: IndexPath) {
        let spendId = spendsData[index.section].spendId
        let successHandler = { [unowned self] (data: Data) throws in
            CoreDataManager.shared.deleteSpend(spendId: spendId)
            DispatchQueue.main.async {
                self.spendsData.remove(at: index.section)
                self.tableView.reloadData()
            }
        }
        var request = setupRequest(
            url: .deleteSpend,
            method: .delete,
            contertType: .json,
            urlParam: String(spendId)
        )
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else { return }
        request.allHTTPHeaderFields = [
           "Authorization": "Bearer " + accessToken,
           "Content-Type": "application/json"
        ]
        performRequest(request: request, successHandler: successHandler)
    }
}
