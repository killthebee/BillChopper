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
    
    private let viewModels: [CollectionTableViewCellViewModel] = [
        CollectionTableViewCellViewModel(viewModels: [
            TileCollectionViewModel(eventTypeName: "apple", eventTypeIcon: UIImage(named: "eventIcon")!),
            TileCollectionViewModel(eventTypeName: "google", eventTypeIcon: UIImage(named: "eventIcon")!),
            TileCollectionViewModel(eventTypeName: "nvidea", eventTypeIcon: UIImage(named: "eventIcon")!),
            TileCollectionViewModel(eventTypeName: "meta", eventTypeIcon: UIImage(named: "eventIcon")!)
        ])
    ]
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(iconView)
        view.addSubview(eventNameTextField)
        view.addSubview(eventNameHelpLable)
        view.addSubview(tableView)
        view.addSubview(eventTypeHelpLable)
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
        eventNameTextField.layer.borderColor = UIColor.black.cgColor
        eventNameTextField.layer.borderWidth = 1
        eventNameTextField.layer.cornerRadius = 15
        eventNameTextField.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        
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
//        let alert = UIAlertController(
//            title: viewModel.name,
//            message: "ookay",
//            preferredStyle: .alert
//        )
//        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
//        present(alert, animated: true)
        print(viewModel.eventTypeName)
    }
}




extension AddEventViewController: UITextFieldDelegate {
    
}
