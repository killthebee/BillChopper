import UIKit


class AddEventViewController: UIViewController {
    
    lazy var iconView: ProfileIcon = setUpIconView()
    lazy var eventNameTextField: UITextField = setUpUsernameTextField()
    lazy var eventNameHelpLable: UILabel = setUpEventNameHelp()
    let eventTypeHelpLable: UILabel = {
        let helpTextLable = UILabel()
        helpTextLable.text = "Select event type"
        return helpTextLable
    }()
    
    private let addUserText: UILabel = {
        let addUserText = UILabel()
        addUserText.text = "add user:"
        
        return addUserText
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
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()
    
    var rawNumber = ""
    
    private let phoneInput: UITextField = {
        // Make a separete phone text field view
        let phoneInput = UITextField()
        
        phoneInput.placeholder = "(999) 111 11 11"
        phoneInput.font = UIFont.boldSystemFont(ofSize: 19)
        phoneInput.autocorrectionType = UITextAutocorrectionType.no
        phoneInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        phoneInput.keyboardType = UIKeyboardType.namePhonePad
        phoneInput.returnKeyType = UIReturnKeyType.done
        phoneInput.tag = 1
        
        return phoneInput
    }()
    
    private let codeInput: UITextField = {
        let codeInput = UITextField()
        
        codeInput.placeholder = "+7"
        codeInput.font = UIFont.boldSystemFont(ofSize: 19)
        codeInput.autocorrectionType = UITextAutocorrectionType.no
        codeInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        codeInput.keyboardType = UIKeyboardType.namePhonePad
        codeInput.returnKeyType = UIReturnKeyType.done
        codeInput.textAlignment = .right
        codeInput.tag = 0
        
        return codeInput
    }()
    
    let phoneNumDelegate = PhoneDelegate()
    
    let addUserButton: UIButton = {
        let addUserButton = UIButton()
        addUserButton.setImage(UIImage(named: "plusIconUser")!, for: .normal)
        addUserButton.addTarget(self, action: #selector(handleAddUser), for: .touchDown)
        
        return addUserButton
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(iconView)
        view.addSubview(eventNameTextField)
        view.addSubview(eventNameHelpLable)
        view.addSubview(tableView)
        view.addSubview(eventTypeHelpLable)
        
        phoneInput.delegate = phoneNumDelegate
        codeInput.delegate = phoneNumDelegate
        view.addSubview(phoneInput)
        view.addSubview(codeInput)
        //this fucking button is ugly
        view.addSubview(addUserButton)
        view.addSubview(addUserText)
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    // I can refactor the shit out of this
    private func setUpIconView(_ image: UIImage = UIImage(named: "eventIcon")!) -> ProfileIcon {
        let profileIcon = ProfileIcon()
        profileIcon.image = image
        // for the fuck sake stop using width to messure height...
        profileIcon.frame = CGRect(
            x: view.frame.size.width * 0.1,
            y: view.frame.size.height * 0.05,
            width: view.frame.size.width * 0.3,
            height: view.frame.size.width * 0.3
        )
        
//        let tapOnIconGestureRecognizer = UITapGestureRecognizer(
//            target: self, action: #selector(handleTapOnIcon)
//        )
//        profileIcon.isUserInteractionEnabled = true
//        profileIcon.addGestureRecognizer(tapOnIconGestureRecognizer)
        
        return profileIcon
    }
    
    private func setUpUsernameTextField() -> UITextField {
        let eventNameTextField = CustomTextField(frame: CGRect(
            x: view.frame.size.width * 0.45,
            y: view.frame.size.height * 0.1,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        ))
        //eventNameTextField.text = "new event name"
        eventNameTextField.placeholder = "new event name"
        eventNameTextField.font = UIFont.boldSystemFont(ofSize: 21)
        eventNameTextField.autocorrectionType = UITextAutocorrectionType.no
        eventNameTextField.clearButtonMode = UITextField.ViewMode.whileEditing
        eventNameTextField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        eventNameTextField.keyboardType = UIKeyboardType.default
        eventNameTextField.returnKeyType = UIReturnKeyType.done
        eventNameTextField.delegate = self
        
        eventNameTextField.sidePadding = eventNameTextField.frame.width * 0.05
        eventNameTextField.topPadding = eventNameTextField.frame.height * 0.1
        eventNameTextField.layer.borderColor = UIColor.quaternaryLabel.cgColor
        eventNameTextField.layer.borderWidth = 1
        eventNameTextField.layer.cornerRadius = 15
        eventNameTextField.backgroundColor = .white
        
        return eventNameTextField
    }
    
    private func setUpEventNameHelp() -> UILabel {
        let eventNameHelpLable = UILabel()
        eventNameHelpLable.frame = CGRect(
            x: view.frame.size.width * 0.47,
            y: view.frame.size.height * 0.14,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        eventNameHelpLable.text = "Name the event"
        return eventNameHelpLable
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = CGRect(
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
        iconView.removeFromSuperview()
        iconView = setUpIconView(viewModel.eventTypeIcon)
        view.addSubview(iconView)
    }
}




extension AddEventViewController: UITextFieldDelegate {
    
}


class PhoneDelegate: NSObject {
    var rawNumber = ""
}


extension PhoneDelegate: UITextFieldDelegate {
        
    
        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            print("hmmm?")
            switch textField.tag {
            case 0:
                if textField.text!.count == 0 && string != "+"{
                    textField.text = "+"
                }
                if textField.text!.count == 4 && range.length == 0{
                    return false
                }
                if range.length != 0 && textField.text!.count - 1 == range.length{
                    textField.text = nil
                    return false
                }
                return true
            case 1:
                if range.lowerBound == 15{
                    return false
                }
                rawNumber = getNewRawNumber(from: rawNumber, range: range, num: string)
                textField.text = getNewNumberText(from: rawNumber, range: range, num: string)
            default:
                break
            }
            return false
        }

}

