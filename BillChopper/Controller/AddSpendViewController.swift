import UIKit

protocol AddSpendDelegate: AnyObject {
    func recalculatePercents()
}

final class AddSpendViewController: UIViewController {
    
    private var eventUsers: [EventUserProtocol] = []
    
    private var spendEvents: [EventProtocol] = [
        spendEvent(eventType: "other", name: "hmm1", users: [
            EventUser(username: "Ilya", imageName: "HombreDefault1"),
            EventUser(username: "Dmitriy", imageName: "HombreDefault1.1"),
            EventUser(username: "Kiril"),
        ]),
        spendEvent(eventType: "party", name: "hmm2", users: [
            EventUser(username: "Dmitriy", imageName: "HombreDefault1.1"),
            EventUser(username: "Kiril"),
        ]),
    ]
    
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
        var events = Array<UIAction>()
        for event in spendEvents {
            events.append(UIAction(
                title: event.name,
                image: UIImage(named: "\(event.eventType)Icon")
            ){
                (action) in
                self.eventUsers = event.users
                self.splitSelectorsView.reloadData()
                self.chooseEventView.chooseEventLable.text = event.name
                
                var userButtons = Array<UIAction>()
                self.selectSplitText.text = R.string.addSpend.selectSplit()
                self.selectSplitText.textColor = .black
                for user in event.users {
                    let userButton = UIAction(
                        title: user.username,
                        image: UIImage(named: user.imageName ?? "HombreDefault1")
                    ) { (action) in
                        self.chooseUserView.chooseEventLable.text = user.username
                        self.chooseUserView.chooseEventImage.image = UIImage(named:  user.imageName ?? "HombreDefault1")
                    }
                    userButtons.append(userButton)
                }
                let menu = UIMenu(
                    title: "choose user",
                    options: .displayInline,
                    children: userButtons
                )
                
                self.chooseUserView.removeFromSuperview()
                self.chooseUserView = ChooseButtonView(
                    text: "choose user",
                    image: UIImage(named: "HombreDefault1")!,
                    menu: menu
                )
                self.view.addSubview(self.chooseUserView)
            })
        }
        let menu = UIMenu(title: "spendEvents", options: .displayInline, children: events)
        let button =  ChooseButtonView(
            text: "choose event",
            image: UIImage(named: "saveIcon")!,
            menu: menu
        )
        
        return button
    }()

    private var chooseUserView: ChooseButtonView = {
        let button = ChooseButtonView(text: "choose user", image: UIImage(named: "HombreDefault1")!)
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
    
    // name lowkey suck...
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
    
    private let eventPayeerContainerView = UIView()
    
    
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
    
    private func addToolbars() {
        let spendNameKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        let spendTotalKeyboardDownButton: UIBarButtonItem = makeKeyboardDownButton()
        
        let spendNameDownView = spendNameKeyboardDownButton.customView as? UIButton
        let spendTotalDownView = spendTotalKeyboardDownButton.customView as? UIButton
        
        [spendNameDownView, spendTotalDownView].forEach(
            {$0?.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)}
        )
        
        spendNameTextField.inputAccessoryView = makeToolbar(
            barItems: [spendNameKeyboardDownButton, flexSpace]
        )
        spendAmountTextField.inputAccessoryView = makeToolbar(
            barItems: [spendTotalKeyboardDownButton, flexSpace]
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        super.viewDidLayoutSubviews()
        
        let eventStackView = UIStackView(arrangedSubviews: [chooseEventText, chooseEventView])
        let payeerStackView = UIStackView(arrangedSubviews: [choosePayerText, chooseUserView])
        [payeerStackView, eventStackView, spendNameStackView, spendTotalStackView
        ].forEach({ stackView in
            stackView.distribution = .fill
            stackView.spacing = 10
            eventPayeerContainerView.addSubview(stackView)
        })
        
        [exitButton, eventPayeerContainerView, chooseEventText, chooseEventView, eventStackView,
         payeerStackView, selectSplitText, splitSelectorsView, saveButton, spendNameStackView,
         spendNameTextField, spendAmountTextField, spendTotalStackView
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        // TODO: make extra container for stacks so they'll be centered
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
    
    func recalculatePercents() {
        var currentSum = 0
        for i in 0 ..< eventUsers.count {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = splitSelectorsView.cellForRow(at: indexPath) as? SplitSelectorViewCell else {
                break
            }
            currentSum += Int(cell.percent.text ?? "0") ?? 0
        }
        var underlineAttriString: NSMutableAttributedString
        
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
        self.selectSplitText.text = nil
        self.selectSplitText.attributedText = underlineAttriString
        self.selectSplitText.addGestureRecognizer(
            UITapGestureRecognizer(target: self, action: #selector(reloadSplit))
        )
    }
    
    @objc func handleSaveEvent(_ sender: UIButton) {
        // gathering data
        // spend name
//        print(spendNameTextField.text)
        // spend amount
//        print(spendAmountTextField.text)
        // current event
//        print(chooseEventView.chooseEventLable.text)
        // current user
//        print(self.chooseUserView.chooseEventLable.text)
//        current split
        for i in 0 ... 15 {
            let indexPath = IndexPath(row: i, section: 0)
            guard let cell = splitSelectorsView.cellForRow(at: indexPath) as? SplitSelectorViewCell else {
                break
            }
            print(cell.percent.text)
        }
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    @objc func doneButtonTapped() {
            view.endEditing(true)
    }
    
    @objc func unselectedTap() {
        self.chooseUserView.chooseEventLable.text = "event is empty"
        self.chooseUserView.chooseEventLable.textColor = .red
    }
    
    @objc func reloadSplit() {
        self.splitSelectorsView.reloadData()
        self.selectSplitText.text = R.string.addSpend.selectSplit()
    }
}

extension AddSpendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var eventUser = eventUsers[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SplitSelectorViewCell.identifier) as? SplitSelectorViewCell else { return UITableViewCell() }
        if eventUsers[indexPath.row].percent == nil {
            let startingSplit = 100 / tableView.numberOfRows(inSection: 0)
            eventUsers[indexPath.row].percent = startingSplit
        }
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
