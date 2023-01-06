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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        setupViews()
    }
    
    private func addSubviews() {
        view.addSubview(chooseEventView)
        view.addSubview(chooseEventText)
        view.addSubview(choosePayerText)
        view.addSubview(chooseUserView)
        view.addSubview(selectSplitText)
        view.addSubview(splitSelectorsView)
        view.addSubview(saveButton)
        view.addSubview(exitButton)
    }
    
    private func setupViews() {
        view.backgroundColor = .white
        splitSelectorsView.dataSource = self
        splitSelectorsView.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        chooseEventText.frame = CGRect(
            x: view.frame.size.width * 0.15,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.2,
            height: view.frame.size.height * 0.05
        )
        chooseEventView.frame = CGRect(
            x: view.frame.size.width * 0.4,
            y: view.frame.size.height * 0.2,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        choosePayerText.frame = CGRect(
            x: view.frame.size.width * 0.15,
            y: view.frame.size.height * 0.3,
            width: view.frame.size.width * 0.2,
            height: view.frame.size.height * 0.05
        )
        chooseUserView.frame = CGRect(
            x: view.frame.size.width * 0.4,
            y: view.frame.size.height * 0.3,
            width: view.frame.size.width * 0.5,
            height: view.frame.size.height * 0.05
        )
        selectSplitText.frame = CGRect(
            x: view.frame.size.width * 0,
            y: view.frame.size.height * 0.4,
            width: view.frame.size.width,
            height: view.frame.size.height * 0.05
        )
        splitSelectorsView.frame = CGRect(
            x: view.frame.size.width * 0.05,
            y: view.frame.size.height * 0.45,
            width: view.frame.size.width * 0.9,
            height: view.frame.size.height * 0.24
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
        return view.frame.size.height * 0.06
    }
    
}
