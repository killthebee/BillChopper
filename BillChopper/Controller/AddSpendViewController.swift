import UIKit

protocol AddSpendDelegate: AnyObject {
    func estimateSplitPercents()
}

final class AddSpendViewController: UIViewController {
    
    // MARK: Data
    unowned var mainVC : MainViewController!
    
    var events: [Event] = []
    private var currentEvent: Event? = nil
    private var payeer: Participant? = nil
    private var participants: [Participant]? = nil
    
    private var eventUsers: [EventUserProtocol] = []
    
    // MARK: UI Elements
    private lazy var spendNameTextField: CustomTextField = {
        let spendNameTextField = CustomTextField()
        spendNameTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.addSpend.newSpendPlaceholder(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        spendNameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        spendNameTextField.autocorrectionType = UITextAutocorrectionType.no
        spendNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        spendNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        spendNameTextField.keyboardType = UIKeyboardType.default
        spendNameTextField.returnKeyType = UIReturnKeyType.done
        spendNameTextField.delegate = self
        
        spendNameTextField.layer.borderColor = UIColor.black.cgColor
        spendNameTextField.layer.borderWidth = 1
        spendNameTextField.layer.cornerRadius = 15
        spendNameTextField.backgroundColor = .white
        spendNameTextField.tag = 0
        
        return spendNameTextField
    }()
    
    private let spendText: UILabel = {
        let lable = UILabel(text: R.string.addSpend.newSpendHelpText())
        lable.textAlignment = .right
        
        return lable
    }()
    
    private lazy var spendAmountTextField: CustomTextField = {
        let spendAmountTextField = CustomTextField()
        spendAmountTextField.attributedPlaceholder = NSAttributedString(
            string: R.string.addSpend.spendTotalAmount(),
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        spendAmountTextField.font = UIFont.boldSystemFont(ofSize: 21)
        spendAmountTextField.autocorrectionType = UITextAutocorrectionType.no
        spendAmountTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        spendAmountTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        spendAmountTextField.keyboardType = UIKeyboardType.phonePad
        spendAmountTextField.returnKeyType = UIReturnKeyType.done
        spendAmountTextField.delegate = self
        
        spendAmountTextField.layer.borderColor = UIColor.black.cgColor
        spendAmountTextField.layer.borderWidth = 1
        spendAmountTextField.layer.cornerRadius = 15
        spendAmountTextField.backgroundColor = .white
        spendAmountTextField.tag = 1
        
        return spendAmountTextField
    }()
    
    private lazy var dateTextField: UITextField = {
        let field = UITextField()
        field.layer.borderColor = UIColor.black.cgColor
        field.layer.borderWidth = 1
        field.layer.cornerRadius = 15
        field.backgroundColor = .white
        field.tag = 1
        field.inputView = datePicker
        field.textAlignment = .center
        
        return field
    }()
    
    private let spendTotalText: UILabel = {
        let lable = UILabel(text: R.string.addSpend.spendTotalText())
        lable.textAlignment = .right
        
        return lable
    }()
    
    private let chooseEventText: UILabel = {
        let lable = UILabel()
        lable.text = R.string.addSpend.event()
        lable.textAlignment = .right
        lable.textColor = .black
        
        return lable
    }()
    
    private lazy var chooseEventView: ChooseButtonView = {
        var eventsButtons = Array<UIAction>()
        for event in events {
            eventsButtons.append(makeEventButton(event))
        }
        let menu = UIMenu(title: "spendEvents", options: .displayInline, children: eventsButtons)
        let button =  ChooseButtonView(
            text: R.string.addSpend.chooseEvent(),
            image: UIImage(named: "saveIcon")!,
            menu: menu
        )
        
        return button
    }()

    private var chooseUserView: ChooseButtonView = {
        let button = ChooseButtonView(
            text:R.string.addSpend.chooseUser(),
            image: UIImage(named: "HombreDefault1")!
        )
        button.chooseButton.addTarget(self, action: #selector(unselectedTap), for: .touchUpInside)
        
        return button
    }()
    
    private  let choosePayerText: UILabel = {
        let lable = UILabel()
        lable.text = R.string.addSpend.payedBy()
        lable.textAlignment = .right
        lable.textColor = .black
        
        return lable
    }()
    
    private let selectSplitText: UILabel = {
        let lable = UILabel()
        lable.text = R.string.addSpend.selectSplit()
        lable.textAlignment = .center
        lable.textColor = .black
        lable.isUserInteractionEnabled = true
        
        return lable
    }()
    
    private let splitSelectorsView: UITableView  = {
        let tableView = UITableView()
        tableView.register(SplitSelectorViewCell.self, forCellReuseIdentifier: SplitSelectorViewCell.identifier)
        tableView.backgroundColor = .white
        
        return tableView
    }()
    
    private let saveButton: SaveButton = {
        let button = SaveButton()
        button.addTarget(self, action: #selector(handleSaveEvent), for: .touchDown)
        
        return button
    }()
    
    let exitButton: UIButton = {
        let button = ExitCross()
        button.addTarget(self, action: #selector(handleExitButtonClicked), for: .touchDown)
        return button
    }()
    
    private let spendDateText: UILabel = {
        let lable = UILabel(text: R.string.addSpend.date())
        lable.textAlignment = .right
        
        return lable
    }()
    
    private let datePicker: UIDatePicker = {
        // TODO: make inputs sliding, so it'll fit on small screens!
        let picker = UIDatePicker()
        picker.datePickerMode = .date
        picker.preferredDatePickerStyle = .wheels
        
        return picker
    }()
    
    private var nameHelpText: UILabel = {
        let nameHelpText = UILabel()
//        nameHelpText.text = R.string.addSpend.nameWorning()
        nameHelpText.font = nameHelpText.font.withSize(15)
        nameHelpText.textAlignment = .center
        nameHelpText.lineBreakMode = .byWordWrapping
        nameHelpText.numberOfLines = 0
        nameHelpText.textColor = .red
        
        return nameHelpText
    }()
    
    private var amountHelpText: UILabel = {
        let amountHelpText = UILabel()
//        amountHelpText.text = R.string.addSpend.amountWorning()
        amountHelpText.font = amountHelpText.font.withSize(15)
        amountHelpText.textAlignment = .center
        amountHelpText.lineBreakMode = .byWordWrapping
        amountHelpText.numberOfLines = 0
        amountHelpText.textColor = .red
        
        return amountHelpText
    }()
    
    // MARK: VC setup
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupViews()
        addToolbars()
    }
    
    private func addSubviews() {
        [choosePayerText, chooseUserView,
         selectSplitText, splitSelectorsView, saveButton, exitButton, eventPayeerContainerView
        ].forEach({view.addSubview($0)})
        
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        splitSelectorsView.dataSource = self
        splitSelectorsView.delegate = self
    }
    
    // MARK: layout
    private let eventPayeerContainerView = UIView()
    
    private func addToolbars() {
        let spendNameKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let spendTotalKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let spendDateKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        let spendNameDownView = spendNameKeyboardDownButton.customView as? UIButton
        let spendTotalDownView = spendTotalKeyboardDownButton.customView as? UIButton
        let spendDateDownView = spendDateKeyboardDownButton.customView as? UIButton
        
        [spendNameDownView, spendTotalDownView].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        spendDateDownView?.addTarget(self, action: #selector(dateDoneButtonTapped), for: .touchUpInside)
        
        spendNameTextField.inputAccessoryView = makeToolbar(
            barItems: [spendNameKeyboardDownButton, flexSpace]
        )
        spendAmountTextField.inputAccessoryView = makeToolbar(
            barItems: [spendTotalKeyboardDownButton, flexSpace]
        )
        dateTextField.inputAccessoryView = makeToolbar(
            barItems: [spendDateKeyboardDownButton, flexSpace]
        )
    }
    
    private lazy var spendNameStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [spendText, spendNameTextField]
        )
        spendNameTextField.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.7).isActive = true
        
        return stack
    }()
    
    private lazy var spendTotalStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [spendTotalText, spendAmountTextField]
        )
        spendAmountTextField.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.7).isActive = true
        
        return stack
    }()
    
    private lazy var eventStackView = UIStackView(arrangedSubviews: [chooseEventText, chooseEventView])
    private lazy var payeerStackView = UIStackView(arrangedSubviews: [choosePayerText, chooseUserView])
    
    private lazy var spendDateStackView: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [spendDateText, dateTextField]
        )
        dateTextField.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.7).isActive = true
        
        return stack
    }()
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        [payeerStackView, eventStackView, spendNameStackView, spendTotalStackView,
         spendDateStackView,
        ].forEach({ stackView in
            stackView.distribution = .fill
            stackView.spacing = 10
            eventPayeerContainerView.addSubview(stackView)
        })
        [nameHelpText, amountHelpText].forEach({eventPayeerContainerView.addSubview($0)})
        [exitButton, eventPayeerContainerView, chooseEventText, chooseEventView, eventStackView,
         payeerStackView, selectSplitText, splitSelectorsView, saveButton, spendNameStackView,
         spendNameTextField, spendAmountTextField, spendTotalStackView, nameHelpText, amountHelpText,
         datePicker, spendDateStackView, spendDateText,
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        let constraints: [NSLayoutConstraint] = [
        
            chooseUserView.widthAnchor.constraint(equalTo: payeerStackView.widthAnchor, multiplier: 0.7),
            chooseEventView.widthAnchor.constraint(equalTo: eventStackView.widthAnchor, multiplier: 0.7),
            
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exitButton.widthAnchor.constraint(equalToConstant: 41),
            exitButton.heightAnchor.constraint(equalToConstant: 41),
            
            eventPayeerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 90),
            eventPayeerContainerView.widthAnchor.constraint(equalToConstant: 300),
            eventPayeerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            eventPayeerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.4),
            
            spendNameStackView.leadingAnchor.constraint(equalTo: eventPayeerContainerView.leadingAnchor),
            spendNameStackView.trailingAnchor.constraint(equalTo: eventPayeerContainerView.trailingAnchor),
            spendNameStackView.heightAnchor.constraint(equalToConstant: 40),
            spendNameStackView.topAnchor.constraint(equalTo: eventPayeerContainerView.topAnchor),
            
            nameHelpText.topAnchor.constraint(equalTo: spendNameStackView.bottomAnchor),
            nameHelpText.widthAnchor.constraint(equalTo: spendNameStackView.widthAnchor, multiplier: 0.9),
            nameHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            eventStackView.widthAnchor.constraint(equalToConstant: 300),
            eventStackView.heightAnchor.constraint(equalToConstant: 40),
            eventStackView.topAnchor.constraint(equalTo: spendNameStackView.bottomAnchor, constant: 30),
            eventStackView.centerXAnchor.constraint(equalTo: eventPayeerContainerView.centerXAnchor),

            payeerStackView.widthAnchor.constraint(equalToConstant: 300),
            payeerStackView.heightAnchor.constraint(equalToConstant: 40),
            payeerStackView.centerXAnchor.constraint(equalTo: eventPayeerContainerView.centerXAnchor),
            payeerStackView.topAnchor.constraint(equalTo: eventStackView.bottomAnchor, constant: 30),
            
            spendTotalStackView.leadingAnchor.constraint(equalTo: eventPayeerContainerView.leadingAnchor),
            spendTotalStackView.trailingAnchor.constraint(equalTo: eventPayeerContainerView.trailingAnchor),
            spendTotalStackView.heightAnchor.constraint(equalToConstant: 40),
            spendTotalStackView.topAnchor.constraint(equalTo: payeerStackView.bottomAnchor, constant: 30),
            
            spendDateStackView.leadingAnchor.constraint(equalTo: eventPayeerContainerView.leadingAnchor),
            spendDateStackView.trailingAnchor.constraint(equalTo: eventPayeerContainerView.trailingAnchor),
            spendDateStackView.heightAnchor.constraint(equalToConstant: 40),
            spendDateStackView.topAnchor.constraint(equalTo: spendTotalStackView.bottomAnchor, constant: 30),
    
            amountHelpText.topAnchor.constraint(equalTo: spendTotalStackView.bottomAnchor),
            amountHelpText.widthAnchor.constraint(equalTo: spendTotalStackView.widthAnchor, multiplier: 0.9),
            amountHelpText.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            selectSplitText.topAnchor.constraint(equalTo: eventPayeerContainerView.bottomAnchor, constant: 20),
            selectSplitText.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            selectSplitText.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            selectSplitText.heightAnchor.constraint(equalToConstant: 30),
            
            saveButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 150),
            
            splitSelectorsView.topAnchor.constraint(equalTo: selectSplitText.bottomAnchor, constant: 10),
            splitSelectorsView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            splitSelectorsView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            splitSelectorsView.bottomAnchor.constraint(equalTo: saveButton.topAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func layoutNewChooseUserButton() {
        self.payeerStackView.removeFromSuperview()
        payeerStackView = UIStackView(arrangedSubviews: [choosePayerText, chooseUserView])
        payeerStackView.distribution = .fill
        payeerStackView.spacing = 10
        eventPayeerContainerView.addSubview(payeerStackView)
    }
    
    // MARK: logic
    private func makeEventUsers(_ participants: [Participant]) {
        let percent = 100 / participants.count
        for participant in participants {
            let image = loadImageFromDiskWith(fileName: participant.imageName ?? "") ?? UIImage(named: "HombreDefault1")
            self.eventUsers.append(EventUser(
                username: participant.username ?? R.string.main.unnamed(),
                percent: percent,
                image: image,
                phone: participant.imageName ?? R.string.addSpend.unknown()
            ))
        }
    }
    
    private func setupUserButtons(_ participants: [Participant]) -> UIMenu {
        var userButtons = Array<UIAction>()
        for (index, user) in self.eventUsers.enumerated() {
            let userButton = UIAction(
                title: user.username,
                image: user.image
            ) { (action) in
                self.payeer = participants[index]
                self.chooseUserView.chooseEventLable.text = user.username
                self.chooseUserView.chooseEventImage.image = user.image
            }
            userButtons.append(userButton)
        }
        let menu = UIMenu(
            title: R.string.addSpend.chooseUser(),
            options: .displayInline,
            children: userButtons
        )
        
        return menu
    }
    
    private func makeEventButton(_ event: Event) -> UIAction {
        var eventButton = UIAction(
            title: event.name ?? "",
            image: UIImage(
                named: "\(reverseConvertEventTypes(type: event.eventType))Icon")
        ) { [unowned self] (action) in
            self.eventUsers = []
            self.currentEvent = event
            guard let participants = event.participants?.allObjects as? [Participant]
            else { return }
            self.participants = participants
            
            makeEventUsers(participants)
            
            self.splitSelectorsView.reloadData()
            self.chooseEventView.chooseEventLable.text = event.name
            self.selectSplitText.text = R.string.addSpend.selectSplit()
            self.selectSplitText.textColor = .black
            
            let usersMenu = setupUserButtons(participants)
            self.chooseUserView = ChooseButtonView(
                text: R.string.addSpend.chooseUser(),
                image: UIImage(named: "HombreDefault1")!,
                menu: usersMenu
            )
            
            layoutNewChooseUserButton()
        }
        
        return eventButton
    }
    
    private func calculatePercentsSum() -> Int {
        var currentSum = 0
        for i in 0 ..< eventUsers.count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = splitSelectorsView.cellForRow(at: indexPath) as? SplitSelectorViewCell else {
                break
            }
            currentSum += Int(cell.percent.text ?? "0") ?? 0
        }
        
        return currentSum
    }
    
    private func makeEstimationMutatableString(
        _ currentSum: Int
    ) -> NSMutableAttributedString {
        let underlineAttriString: NSMutableAttributedString!
        
        if currentSum > 100 {
            underlineAttriString = NSMutableAttributedString(
                string: R.string.addSpend.percentMore()
            )
            let range1 = (
                R.string.addSpend.percentMore() as NSString).range(of: R.string.addSpend.reloadRange())
            
            underlineAttriString.addAttribute(
                NSAttributedString.Key.foregroundColor, value: customGreen, range: range1
            )
        } else if currentSum < 99 {
            underlineAttriString = NSMutableAttributedString(
                string: R.string.addSpend.percentLess()
            )
            let range1 = (
                R.string.addSpend.percentMore() as NSString).range(of: R.string.addSpend.reloadRange())
            
            underlineAttriString.addAttribute(
                NSAttributedString.Key.foregroundColor, value: customGreen, range: range1
            )
        } else {
            underlineAttriString = NSMutableAttributedString(
                string: R.string.addSpend.ok()
            )
        }
        
        return underlineAttriString
    }
    
    func estimateSplitPercents() {
        let currentSum = calculatePercentsSum()
        let underlineAttriString = makeEstimationMutatableString(currentSum)
        self.selectSplitText.text = nil
        self.selectSplitText.attributedText = underlineAttriString
        self.selectSplitText.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(reloadSplit))
        )
    }
    
    private func setWarnings(erros: [String: String]) {
        if let nameError = erros["name"] {
            nameHelpText.text = nameError
        }
        if let amountError = erros["amount"] {
            amountHelpText.text = amountError
        }
        if let splitError = erros["split"] {
            selectSplitText.textColor = .red
        }
    }
    
    private func clearWarnings() {
        nameHelpText.text = ""
        amountHelpText.text = ""
        selectSplitText.textColor = .black
    }
    
    private func gatherAndValidateData() -> [String: String]? {
        let verifier = Verifier()
        let (isValid, data) = verifier.validateNewSpend(
            spendNameTextField.text,
            spendAmountTextField.text,
            calculatePercentsSum()
        )
        if !isValid {
            setWarnings(erros: data)
            return nil
        }
        
        return data
    }
    
    private func makeSplitDict() -> [String: Int8] {
        var split: [String: Int8] = [:]
        for i in 0 ..< eventUsers.count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = splitSelectorsView.cellForRow(at: indexPath) as? SplitSelectorViewCell else {
                break
            }
            split[cell.phone] = Int8(cell.percent.text ?? "0") ?? 0
        }
        
        return split
    }
    
    private func makeRequest(
        _ spendName: String,
        _ dateString: String,
        _ amount: String,
        _ split: [String: Int8]
    ) -> URLRequest? {
        let splitJson = try! JSONSerialization.data(withJSONObject: split)
        let splitString = String(data: splitJson, encoding: .utf8)!
        let spendData: [String: Any] = [
            "split": splitString,
            "name": spendName,
            "payeer": ["username": payeer?.imageName],
            "event": ["id": currentEvent?.eventId, "name": currentEvent?.name],
            "date": dateString,
            "amount": amount,
        ]
        let jsonData = try? JSONSerialization.data(withJSONObject: spendData)
        var request = setupRequest(url: .createSpend, method: .post, body: jsonData)
        guard let accessToken = KeychainHelper.standard.readToken(
            service: "access-token", account: "backend-auth"
        ) else { return nil }
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        
        return request
    }
    
    private func gatherDate() -> (createdDate: Date, dateString: String) {
        let dateFormatter = DateFormatter()
        let userLocale = Locale(identifier: Locale.current.languageCode ?? "ru_RU")
        dateFormatter.locale = userLocale
        dateFormatter.dateFormat = "YYYY-MM-dd"
        let createdDate = datePicker.date
        let dateString = dateFormatter.string(from: createdDate)
        
        return (createdDate, dateString)
    }
    
    @objc func handleSaveEvent(_ sender: UIButton) {
        clearWarnings()
        guard let inputData = gatherAndValidateData() else { return }
        
        let (createdDate, dateString) = gatherDate()

        let split = makeSplitDict()
        
        guard let request = makeRequest(
            inputData["name"]!,
            dateString,
            inputData["amount"]!,
            split
        ) else { return }
        let successHanlder = { [unowned self] (data: Data) throws in
            let responseObject = try JSONDecoder().decode(SpendCreateSuccess.self, from: data)
            
            DispatchQueue.main.async {
                let newSpend = CoreDataManager.shared.createSpend(
                    name: inputData["name"]!,
                    eventId: self.currentEvent?.objectID,
                    payeerUsername: self.payeer?.username,
                    date: createdDate,
                    spendId: responseObject.spendId,
                    totalAmount: Int16(inputData["amount"]!) ?? 0,
                    split: split
                )
                if newSpend == nil { return }
                self.mainVC.spendsData.append(newSpend!)
                self.mainVC.tableView.reloadData()
                self.dismiss(animated: true)
            }
        }
        performRequest(request: request, successHandler: successHanlder)
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    
    @objc func dateDoneButtonTapped() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        view.endEditing(true)
    }
    
    @objc func unselectedTap() {
        self.chooseUserView.chooseEventLable.text = R.string.addSpend.eventIsEmpty()
        self.chooseUserView.chooseEventLable.textColor = .red
    }
    
    @objc func reloadSplit() {
        self.selectSplitText.textColor = .black
        self.splitSelectorsView.reloadData()
        self.selectSplitText.text = R.string.addSpend.selectSplit()
    }
}

extension AddSpendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var eventUser = eventUsers[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SplitSelectorViewCell.identifier) as? SplitSelectorViewCell else { return UITableViewCell() }
        cell.configure(eventUsers[indexPath.row], self)
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventUsers.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}

extension AddSpendViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string != "" && textField.tag == 1{
            guard let newNum = Int(string) else {
                return false
            }
        }
        return true
    }
}

extension AddSpendViewController: AddSpendDelegate {}
