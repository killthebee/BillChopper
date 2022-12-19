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

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        chooseEventView.configure(text: "dummy event", image: UIImage(named: "saveIcon")!)
        chooseUserView.configure(text: "dummy user", image: UIImage(named: "HombreDefault1")!)
        view.addSubview(chooseEventView)
        view.addSubview(chooseEventText)
        view.addSubview(choosePayerText)
        view.addSubview(chooseUserView)
        
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
    }
}
