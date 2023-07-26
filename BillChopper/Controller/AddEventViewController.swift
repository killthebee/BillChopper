import UIKit

final class AddEventViewController: UIViewController {
    
    var currentUserPhone: String? = nil
    unowned var mainVC: MainViewController!
    
    private var iconView = ProfileIcon().setUpIconView(
        R.image.eventIcon()!
    )
    
    private lazy var eventNameTextField: CustomTextField = {
        let eventNameTextField = CustomTextField()
        eventNameTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.addEvent.newEventPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        eventNameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        eventNameTextField.autocorrectionType = UITextAutocorrectionType.no
        eventNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        eventNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        eventNameTextField.keyboardType = UIKeyboardType.default
        eventNameTextField.returnKeyType = UIReturnKeyType.done
        eventNameTextField.delegate = self
        
        eventNameTextField.layer.borderColor = UIColor.secondaryLabel.cgColor
        eventNameTextField.layer.borderWidth = 1
        eventNameTextField.layer.cornerRadius = 15
        eventNameTextField.backgroundColor = .white
        
        return eventNameTextField
    }()
    
    private let eventNameHelpLable = UILabel(text: R.string.addEvent.nameEventHelpText())
    
    private let eventTypeHelpLable = UILabel(text: R.string.addEvent.eventTypeHelpText())
    
    private let invalidPhoneWarningLable: UILabel = {
        let invalidPhoneWarningLable = UILabel()
        invalidPhoneWarningLable.font = invalidPhoneWarningLable.font.withSize(15)
        invalidPhoneWarningLable.lineBreakMode = .byWordWrapping
        invalidPhoneWarningLable.numberOfLines = 0
        invalidPhoneWarningLable.textColor = .red
        
        return invalidPhoneWarningLable
    }()
    
    private let addUserText = UILabel(text: R.string.addEvent.addUser())
    
    private let carouselTableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.separatorStyle = .none
        
        return table
    }()
    
    private let userTableView: UITableView = {
        let table = UITableView()
        table.register(UserTableViewCell.self, forCellReuseIdentifier: UserTableViewCell.identifier)
        table.backgroundColor = .white
        // TODO: need a fix that looks more pleasing
        table.alwaysBounceVertical = false
        
        return table
    }()
    
    private let phoneInput = PhoneInput(isCode: false)
    
    private let codeInput = PhoneInput(isCode: true)
    
    private let addUserButton: UIButton = {
        let addUserButton = UIButton()
        addUserButton.setImage(R.image.plusIconUser()!, for: .normal)
        addUserButton.addTarget(self, action: #selector(handleAddUser), for: .touchDown)
        
        return addUserButton
    }()
    
    private let saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(handleSaveEvent), for: .touchDown)
        
        return button
    }()
    
    private let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        
        return button
    }()
    
    private var viewModels: [CollectionTableViewCellViewModel] = [
        CollectionTableViewCellViewModel(viewModels: [
            TileCollectionViewModel(
                eventTypeName: R.string.addEvent.tripEventType(),
                eventTypeIcon: R.image.tripIcon()!,
                backgroundColor: .white
            ),
            TileCollectionViewModel(
                eventTypeName: R.string.addEvent.purchaseEventType(),
                eventTypeIcon: R.image.purchaseIcon()!,
                backgroundColor: .white),
            TileCollectionViewModel(
                eventTypeName: R.string.addEvent.partyEventType(),
                eventTypeIcon: R.image.partyIcon()!,
                backgroundColor: .white
            ),
            TileCollectionViewModel(
                eventTypeName: R.string.addEvent.otherEventType(),
                eventTypeIcon: R.image.otherIcon()!,
                backgroundColor: .white
            )
        ])
    ]
    
    private var currentEventType = "other"
    
    private var rawNumber = ""
    
    private let phoneNumDelegate = PhoneInputDelegate()
    private let userTableDelegateAndDataSource = UserTableDelegateAndDataSource()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        (UIApplication.shared.delegate as! AppDelegate).restrictRotation = .portrait
        setupViews()
        addSubviews()
        addToolbar()
    }
    
    private func addToolbar() {
        let continueButton = UIBarButtonItem(
            title: "Continue", style: .plain,target: self, action: nil
        )
        let clearButton = UIBarButtonItem(
            title: "Clear", style: .plain,target: self, action: nil
        )
        
        let codeKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let phoneKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let eventNameKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        continueButton.tintColor = .systemGray
        clearButton.tintColor = .systemGray
        continueButton.action = #selector(continueTapped)
        clearButton.action = #selector(clearTapped)
        
        let CodeKeyboardDownView = codeKeyboardDownButton.customView as? UIButton
        let PhoneKeyboardDownView = phoneKeyboardDownButton.customView as? UIButton
        let eventNameKeyboardVied = eventNameKeyboardDownButton.customView as? UIButton
        [CodeKeyboardDownView, PhoneKeyboardDownView, eventNameKeyboardVied
        ].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        codeInput.inputAccessoryView = makeToolbar(
            barItems: [codeKeyboardDownButton, flexSpace, continueButton]
        )
        phoneInput.inputAccessoryView = makeToolbar(
            barItems: [phoneKeyboardDownButton, flexSpace, clearButton]
        )
        eventNameTextField.inputAccessoryView = makeToolbar(
            barItems: [eventNameKeyboardDownButton, flexSpace]
        )
        
        phoneNumDelegate.continueButton = continueButton
        phoneNumDelegate.clearButton = clearButton
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        
        phoneInput.delegate = phoneNumDelegate
        codeInput.delegate = phoneNumDelegate
        
        carouselTableView.dataSource = self
        carouselTableView.delegate = self
        
        userTableView.delegate = userTableDelegateAndDataSource
        userTableView.dataSource = userTableDelegateAndDataSource
    }
    
    private func addSubviews() {
        [topContainerView, carouselTableView, eventTypeHelpLable, splitSelectorStack, addUserSplitStack,
         exitButton, userTableView, saveButton, invalidPhoneWarningLable
        ].forEach({view.addSubview($0)})
        [iconView, eventNameTextField, eventNameHelpLable].forEach({topContainerView.addSubview($0)})
    }
    
    private let topContainerView = UIView()
    private let splitSelectorStack = UIStackView()
    private lazy var addUserSplitStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [self.addUserText, self.codeInput, self.phoneInput]
        )
        stack.distribution = .fill
        stack.spacing = 10
        self.addUserButton.translatesAutoresizingMaskIntoConstraints = false
        self.addUserButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.addUserButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        stack.addArrangedSubview(self.addUserButton)
        stack.setCustomSpacing(5, after: stack.arrangedSubviews[1])
        
        return stack
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [exitButton, topContainerView, iconView, eventNameTextField, eventNameHelpLable, carouselTableView,
         eventTypeHelpLable, saveButton, splitSelectorStack, addUserSplitStack, userTableView,
         invalidPhoneWarningLable,
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        splitSelectorStack.spacing = 10
        
        let constraints: [NSLayoutConstraint] = [
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exitButton.widthAnchor.constraint(equalToConstant: 41),
            exitButton.heightAnchor.constraint(equalToConstant: 41),
            
            topContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 40),
            topContainerView.widthAnchor.constraint(equalToConstant: 320),
            topContainerView.heightAnchor.constraint(equalToConstant: 120),
            topContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            iconView.topAnchor.constraint(equalTo: topContainerView.topAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 120),
            iconView.heightAnchor.constraint(equalToConstant: 120),
            iconView.leadingAnchor.constraint(equalTo: topContainerView.leadingAnchor),
            
            eventNameTextField.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            eventNameTextField.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 10),
            eventNameTextField.centerYAnchor.constraint(equalTo: iconView.centerYAnchor),
            eventNameTextField.heightAnchor.constraint(equalToConstant: 40),
            
            eventNameHelpLable.topAnchor.constraint(equalTo: eventNameTextField.bottomAnchor),
            eventNameHelpLable.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 15),
            eventNameHelpLable.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            eventNameHelpLable.heightAnchor.constraint(equalToConstant: 30),
            
            carouselTableView.topAnchor.constraint(equalTo: topContainerView.bottomAnchor, constant: 20),
            carouselTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            carouselTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            carouselTableView.heightAnchor.constraint(equalToConstant: 40),
            
            eventTypeHelpLable.topAnchor.constraint(equalTo: carouselTableView.bottomAnchor),
            eventTypeHelpLable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            eventTypeHelpLable.trailingAnchor.constraint(equalTo: topContainerView.trailingAnchor),
            eventTypeHelpLable.heightAnchor.constraint(equalToConstant: 30),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            
            addUserSplitStack.topAnchor.constraint(equalTo: eventTypeHelpLable.bottomAnchor, constant: 20),
            addUserSplitStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            addUserSplitStack.heightAnchor.constraint(equalToConstant: 40),
            
            invalidPhoneWarningLable.topAnchor.constraint(equalTo: addUserSplitStack.bottomAnchor, constant: 10),
            invalidPhoneWarningLable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            invalidPhoneWarningLable.widthAnchor.constraint(equalTo: addUserSplitStack.widthAnchor, multiplier: 0.9),
            
            userTableView.topAnchor.constraint(equalTo: eventTypeHelpLable.bottomAnchor, constant: 90),
            userTableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userTableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            userTableView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
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
            x: addUserSplitStack.frame.minX + 5, y: addUserSplitStack.frame.maxY + 5
        ))
        path.addLine(to: CGPoint(x: addUserSplitStack.frame.maxX - 5, y: addUserSplitStack.frame.maxY + 5))
        path.close()
        
        return path
    }
    
    @objc func handleAddUser(_ sender: UIButton) {
        guard let phone = self.phoneInput.text,
              let code = self.codeInput.text
        else {
            self.invalidPhoneWarningLable.text = R.string.addEvent.notProvided()
            return
        }
        
        let userFetchSuccessHandler = { [unowned self] (data: Data) throws in
            let responsObject = try JSONDecoder().decode(UserFetch.self, from: data)
            DispatchQueue.main.async {
                // wounder whether it'll create retain cycle xd
                guard let delegate = self.userTableView.delegate as? UserTableDelegateAndDataSource else {
                    return
                }
                let newEventUser = newEventUser(
                    username: responsObject.first_name,
                    phone: code + phone,
                    imageUrl: responsObject.profile.profile_image ?? nil
                )
                delegate.newEventUsers.append(newEventUser)
                self.userTableView.reloadData()
                self.invalidPhoneWarningLable.text = nil
            }
        }
        
        let fetchFailureHandler = { [unowned self] (data: Data) throws in
            let responseObject = try JSONDecoder().decode(userFetchError.self, from: data)
            DispatchQueue.main.async {
                if responseObject.detail == "Not found." {
                    guard let delegate = self.userTableView.delegate as? UserTableDelegateAndDataSource else {
                        return
                    }
                    delegate.newEventUsers.append(newEventUser(phone: code + phone))
                    self.userTableView.reloadData()
                    self.invalidPhoneWarningLable.text = nil
                    return
                }
                self.invalidPhoneWarningLable.text = responseObject.detail
            }
        }
        
        let verifier = Verifier()
        let cleanPhoneNumber = verifier.stripPhoneNumber(phone: code + phone)
        let isValidPhone = verifier.isValidPhone(phone: cleanPhoneNumber)
        guard isValidPhone else {
            self.invalidPhoneWarningLable.text = R.string.addEvent.phoneNotValid()
            return
        }
        let json: [String: Any] = ["username": cleanPhoneNumber]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = setupRequest(url: .fetchUserData, method: .post, body: jsonData)
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else { return }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        performRequest(
            request: request,
            successHandler: userFetchSuccessHandler,
            failureHandler: fetchFailureHandler
        )
    }
    
    @objc func handleSaveEvent(_ sender: UIButton) {
        guard let eventName = eventNameTextField.text,
              Verifier().isValidEventName(eventName: eventName) else {
            self.eventNameHelpLable.textColor = .red
            self.eventNameHelpLable.text = "Event name isn't valid"
            return
        }
        
        guard let delegate = self.userTableView.delegate as? UserTableDelegateAndDataSource else {
            return
        }
        
        if !Verifier().UsersAreAdded(users: delegate.newEventUsers) {
            self.invalidPhoneWarningLable.text = "no user were added!"
            return
        }
        delegate.newEventUsers.append(
            newEventUser(
                username: R.string.main.you(),
                phone: self.currentUserPhone!
            )
        )
        let usernames = delegate.newEventUsers.map {
            ["username": Verifier().stripPhoneNumber(phone: $0.phone)]
        }
        let json: [String: Any] = [
            "participants": usernames,
            "name": eventName,
            "event_type": convertEventTypes(type:currentEventType)
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = setupRequest(url: .createEvent, method: .post, body: jsonData)
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else {
            return
        }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        let successHanlder = { [unowned self] (data: Data) throws in
            // TODO: make a success notification bar
            let responseObject = try JSONDecoder().decode(EventCreated.self, from: data)
            
            DispatchQueue.main.async {
                let newEvent = CoreDataManager.shared.createEvent(
                    eventId: responseObject.id,
                    name: eventName,
                    eventType: Int16(convertEventTypes(type:currentEventType)),
                    users: delegate.newEventUsers
                )
                if newEvent == nil { return }
                self.mainVC.eventButtonData.append(newEvent!)
                dismiss(animated: true)
            }
        }
        performRequest(request: request, successHandler: successHanlder)
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func continueTapped() {
        phoneInput.becomeFirstResponder()
    }
    
    @objc func clearTapped() {
        let phoneDelegate = phoneInput.delegate as? PhoneInputDelegate
        let codeDelegate = codeInput.delegate as? PhoneInputDelegate
        phoneDelegate?.rawNumber = ""
        codeDelegate?.rawNumber = ""
        phoneDelegate?.clearButton?.tintColor = .systemGray
        codeDelegate?.continueButton?.tintColor = .systemGray
        codeInput.text = nil
        phoneInput.text = nil
        codeInput.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped() {
            view.endEditing(true)
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
    
}

extension AddEventViewController: CollectionTableViewCellDelegate {
    func collectionViewDidTapItem(with viewModel: TileCollectionViewModel) {
        currentEventType = viewModel.eventTypeName
        iconView.removeFromSuperview()
        iconView = ProfileIcon().setUpIconView(viewModel.eventTypeIcon)
        view.addSubview(iconView)
    }
}

extension AddEventViewController: UITextFieldDelegate { }

class UserTableDelegateAndDataSource: NSObject {
    var newEventUsers: [newEventUserProtocol] = []
}

extension UserTableDelegateAndDataSource: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newEventUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var newEventUser = newEventUsers[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: UserTableViewCell.identifier,
            for: indexPath
        ) as? UserTableViewCell else {
            fatalError()
        }
        cell.configure(newEventUser)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
