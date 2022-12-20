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
    
    let selectSplitView: SelectSplitView = SelectSplitView()
    
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
        view.addSubview(selectSplitView)
        
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
        selectSplitView.frame = CGRect(
            x: view.frame.size.width * 0.05,
            y: view.frame.size.height * 0.45,
            width: view.frame.size.width * 0.9,
            height: view.frame.size.height * 0.05
        )
    }
}
