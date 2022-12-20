import UIKit


class AddSpendViewController: UIViewController {
    
    let chooseEventText: UILabel = {
        let lable = UILabel()
        lable.text = "event"
        lable.textAlignment = .right
        return lable
    }()
    
    let chooseEventView: ChooseButtonView = ChooseButtonView()
    let chooseUserView: ChooseButtonView = ChooseButtonView()
    
    let choosePayerText: UILabel = {
        let lable = UILabel()
        lable.text = "payed by"
        lable.textAlignment = .right
        return lable
    }()
    
    let selectSplitText: UILabel = {
        let lable = UILabel()
        lable.text = "select split"
        lable.textAlignment = .center
        return lable
    }()
    
    let splitSelectorsView: UITableView  = {
        let tableView = UITableView()
        tableView.register(SplitSelectorViewCell.self, forCellReuseIdentifier: SplitSelectorViewCell.identifier)
        
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        chooseEventView.configure(text: "dummy event", image: UIImage(named: "saveIcon")!)
        chooseUserView.configure(text: "dummy user", image: UIImage(named: "HombreDefault1")!)
        view.addSubview(chooseEventView)
        view.addSubview(chooseEventText)
        view.addSubview(choosePayerText)
        view.addSubview(chooseUserView)
        view.addSubview(selectSplitText)
        
        splitSelectorsView.dataSource = self
        splitSelectorsView.delegate = self
        
        view.addSubview(splitSelectorsView)
        
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
    }
}


extension AddSpendViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SplitSelectorViewCell.identifier) as? SplitSelectorViewCell else { return UITableViewCell() }

        return cell 
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height * 0.06
    }
    
}
