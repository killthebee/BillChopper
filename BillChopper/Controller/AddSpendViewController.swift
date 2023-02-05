import UIKit

final class AddSpendViewController: UIViewController {
    
    private let chooseEventText: UILabel = {
        let lable = UILabel()
        lable.text = R.string.addSpend.event()
        lable.textAlignment = .right
        lable.textColor = .black
        
        return lable
    }()
    
    private let chooseEventView = ChooseButtonView(text: "dummy event", image: UIImage(named: "saveIcon")!)
    private let chooseUserView = ChooseButtonView(text: "dummy user", image: UIImage(named: "HombreDefault1")!)
    
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
    
    private let eventPayeerContainerView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupViews()
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let eventStackView = UIStackView(arrangedSubviews: [chooseEventText, chooseEventView])
        let payeerStackView = UIStackView(arrangedSubviews: [choosePayerText, chooseUserView])
        [payeerStackView, eventStackView].forEach({ stackView in
            stackView.distribution = .fill
            stackView.spacing = 10
            eventPayeerContainerView.addSubview(stackView)
        })
        
        [exitButton, eventPayeerContainerView, chooseEventText, chooseEventView, eventStackView, payeerStackView, selectSplitText, splitSelectorsView, saveButton
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let constraints: [NSLayoutConstraint] = [
            
            chooseUserView.widthAnchor.constraint(equalTo: payeerStackView.widthAnchor, multiplier: 0.7),
            chooseEventView.widthAnchor.constraint(equalTo: eventStackView.widthAnchor, multiplier: 0.7),
            
            exitButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 15),
            exitButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            exitButton.widthAnchor.constraint(equalToConstant: 41),
            exitButton.heightAnchor.constraint(equalToConstant: 41),
            
            eventPayeerContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            eventPayeerContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            eventPayeerContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            eventPayeerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
            
            eventStackView.widthAnchor.constraint(equalToConstant: 300),
            eventStackView.heightAnchor.constraint(equalToConstant: 40),
            eventStackView.centerYAnchor.constraint(equalTo: eventPayeerContainerView.centerYAnchor, constant:  -30),
            eventStackView.centerXAnchor.constraint(equalTo: eventPayeerContainerView.centerXAnchor),
            
            payeerStackView.widthAnchor.constraint(equalToConstant: 300),
            payeerStackView.heightAnchor.constraint(equalToConstant: 40),
            payeerStackView.centerXAnchor.constraint(equalTo: eventPayeerContainerView.centerXAnchor),
            payeerStackView.topAnchor.constraint(equalTo: eventStackView.bottomAnchor, constant: 30),
            
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
    
    @objc func handleSaveEvent(_ sender: UIButton) {
        print("save spend pls")
    }
    
    @objc func handleExitButtonClicked(_ sender: UIButton) {
        dismiss(animated: true)
    }
}


extension AddSpendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SplitSelectorViewCell.identifier) as? SplitSelectorViewCell else { return UITableViewCell() }
        cell.percent.text = String(100 / tableView.numberOfRows(inSection: 0))
        
        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
}
