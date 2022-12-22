import UIKit


class AddEventViewController: UIViewController {
    
    var iconView = ProfileIcon().setUpIconView(UIImage(named: "eventIcon")!)
    
    lazy var eventNameTextField: CustomTextField = {
        let eventNameTextField = CustomTextField()
        eventNameTextField.placeholder = "new event name"
        eventNameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        eventNameTextField.autocorrectionType = UITextAutocorrectionType.no
        eventNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        eventNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        eventNameTextField.keyboardType = UIKeyboardType.default
        eventNameTextField.returnKeyType = UIReturnKeyType.done
        eventNameTextField.delegate = self
        
        eventNameTextField.layer.borderColor = UIColor.quaternaryLabel.cgColor
        eventNameTextField.layer.borderWidth = 1
        eventNameTextField.layer.cornerRadius = 15
        eventNameTextField.backgroundColor = .white
        
        return eventNameTextField
    }()
    
    let eventNameHelpLable = UILabel(text: "Name the event")
    
    let eventTypeHelpLable = UILabel(text: "Select event type")
    
    let addUserText = UILabel(text: "add user:")
    
    let carouselTableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    let userTableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        return table
    }()
    
    let phoneInput = PhoneInput(isCode: false)
    
    let codeInput = PhoneInput(isCode: true)
    
    let addUserButton: UIButton = {
        let addUserButton = UIButton()
        addUserButton.setImage(UIImage(named: "plusIconUser")!, for: .normal)
        addUserButton.addTarget(self, action: #selector(handleAddUser), for: .touchDown)
        
        return addUserButton
    }()
    
    let saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(handleSaveEvent), for: .touchDown)
        
        return button
    }()
    
    let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        return button
    }()
    
    private var viewModels: [CollectionTableViewCellViewModel] = [
        CollectionTableViewCellViewModel(viewModels: [
            TileCollectionViewModel(
                eventTypeName: "trip",
                eventTypeIcon: UIImage(named: "tripIcon")!,
                backgroundColor: .white
            ),
            TileCollectionViewModel(
                eventTypeName: "purchase",
                eventTypeIcon: UIImage(named: "purchaseIcon")!,
                backgroundColor: .white),
            TileCollectionViewModel(
                eventTypeName: "party",
                eventTypeIcon: UIImage(named: "partyIcon")!,
                backgroundColor: .white
            ),
            TileCollectionViewModel(
                eventTypeName: "other",
                eventTypeIcon: UIImage(named: "otherIcon")!,
                backgroundColor: .white
            )
        ])
    ]
    
    var rawNumber = ""
    
    let phoneNumDelegate = PhoneInputDelegate()
    let userTableDelegateAndDataSource = UserTableDelegateAndDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(iconView)
        view.addSubview(eventNameTextField)
        view.addSubview(eventNameHelpLable)
        view.addSubview(carouselTableView)
        view.addSubview(eventTypeHelpLable)
        view.addSubview(exitButton)
        view.addSubview(phoneInput)
        view.addSubview(codeInput)
        //this fucking button is ugly or not..?
        view.addSubview(addUserButton)
        view.addSubview(addUserText)
        view.addSubview(userTableView)
        view.addSubview(saveButton)
        
        phoneInput.delegate = phoneNumDelegate
        codeInput.delegate = phoneNumDelegate
        
        carouselTableView.dataSource = self
        carouselTableView.delegate = self
        
        userTableView.delegate = userTableDelegateAndDataSource
        userTableView.dataSource = userTableDelegateAndDataSource
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        iconView.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.08,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        eventNameTextField.frame = CGRect(
            x: view.frame.size.width * 0.45,
            y: view.frame.size.height * 0.13,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        eventNameHelpLable.frame = CGRect(
            x: view.frame.size.width * 0.47,
            y: view.frame.size.height * 0.17,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        carouselTableView.frame = CGRect(
            x: 0,
            y: view.frame.size.height * 0.25,
            width: view.frame.size.width,
            height: view.frame.size.height * 0.05
        )
        eventTypeHelpLable.frame = CGRect(
            x: view.frame.size.width * 0.05,
            y: view.frame.size.height * 0.3,
            width: view.frame.size.width * 0.9,
            height: view.frame.size.height * 0.05
        )
        phoneInput.frame = CGRect(
            x: view.frame.size.width * 0.45,
            y: view.frame.size.height * 0.37,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.05
        )
        codeInput.frame = CGRect(
            x: view.frame.size.width * 0.29,
            y: view.frame.size.height * 0.37,
            width: view.frame.size.width * 0.15,
            height: view.frame.size.height * 0.05
        )
        addUserButton.frame = CGRect(
            x: view.frame.size.width * 0.81,
            y: view.frame.size.height * 0.378,
            width: view.frame.size.height * 0.038,
            height: view.frame.size.height * 0.038
        )
        addUserText.frame = CGRect(
            x: view.frame.size.width * 0.12,
            y: view.frame.size.height * 0.37,
            width: view.frame.size.width * 0.35,
            height: view.frame.size.height * 0.05
        )
        userTableView.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.45,
            width: view.frame.size.width * 0.8,
            height: view.frame.size.height * 0.3
        )
        saveButton.frame = CGRect(
            x: view.frame.size.width * 0.3,
            y: view.frame.size.height * 0.8,
            width: view.frame.size.width * 0.4,
            height: view.frame.size.height * 0.05
        )
        exitButton.frame = CGRect(
            x: view.bounds.size.width * 0.85,
            y: view.bounds.size.height * 0.05,
            width: view.bounds.size.width * 0.1,
            height: view.bounds.size.width * 0.1
        )
        
        eventNameTextField.sidePadding = eventNameTextField.frame.width * 0.05
        eventNameTextField.topPadding = eventNameTextField.frame.height * 0.1
        addLayer()
    }
    
    private func addLayer() {
        let middleLineLayer = CAShapeLayer()
        view.layer.addSublayer(middleLineLayer)
        
        middleLineLayer.strokeColor = UIColor.darkGray.cgColor
        middleLineLayer.fillColor = UIColor.white.cgColor
        middleLineLayer.lineWidth = 1
        middleLineLayer.path = getMiddleLinePath().cgPath
    }
    
    private func getMiddleLinePath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: view.frame.size.width * 0.1, y: view.frame.size.height * 0.42
        ))
        path.addLine(to: CGPoint(x: view.frame.size.width * 0.9, y: view.frame.size.height * 0.42))
        path.close()
        
        return path
    }
    
    @objc func handleAddUser(_ sender: UIButton) {
        print("add user pls")
    }
    
    @objc func handleSaveEvent(_ sender: UIButton) {
        print("save event pls")
    }
}


extension AddEventViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let viewModel = viewModels[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CollectionTableViewCell.identifier,
            for: indexPath
        ) as? CollectionTableViewCell else {
            fatalError()
        }
        cell.configure(with: viewModel)
        cell.delegatee = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension AddEventViewController: CollectionTableViewCellDelegate {
    func collectionViewDidTapItem(with viewModel: TileCollectionViewModel) {
        iconView.removeFromSuperview()
        iconView = ProfileIcon().setUpIconView(viewModel.eventTypeIcon)
        view.addSubview(iconView)
    }
}


extension AddEventViewController: UITextFieldDelegate {
    
}


class UserTableDelegateAndDataSource: NSObject {
    // TODO: fetch array with user models here
}


extension UserTableDelegateAndDataSource: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.identifier,
            for: indexPath
        ) as? UserTableViewCell else {
            fatalError()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.size.height * 0.25
    }
}
