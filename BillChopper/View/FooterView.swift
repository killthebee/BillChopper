import UIKit


enum balanceType: String {
    case borrow = "you borrowed"
    case owe = "you lent"
}


final class FooterView: UIView {
    
    // TODO: Hide it somewhere else
    let screenRect = UIScreen.main.bounds
    let tenthOfWidnowWidth = UIScreen.main.bounds.width / 10
    let tenthOfWindowHeight = UIScreen.main.bounds.size.height / 10
    
    let plusIcon = UIImage(named:"plusIcon")
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addLayer()
        
        let plusIconView = setupPlusIconView()
        let balanceView = setupBalanceView()
        let eventsView = setupEventsView()
        self.addSubview(plusIconView)
        self.addSubview(balanceView)
        self.addSubview(eventsView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addLayer() {
        let shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        
        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = getPath().cgPath
        
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: tenthOfWindowHeight * 8.5))
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 4, y: tenthOfWindowHeight * 8.5))
        path.addArc(
            withCenter: CGPoint(x: tenthOfWidnowWidth * 5, y: tenthOfWindowHeight * 8.5),
            radius: tenthOfWidnowWidth * 1,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 10, y: tenthOfWindowHeight * 8.5))
        path.addLine(to: CGPoint(x: tenthOfWidnowWidth * 10, y: tenthOfWindowHeight * 10))
        path.addLine(to: CGPoint(x: 0, y: tenthOfWindowHeight * 10))
        path.addLine(to: CGPoint(x: 0, y: tenthOfWindowHeight * 8.5))
        path.close()
        return path
    }
    
    private func setupPlusIconView() -> UIImageView {
        let iconView = UIImageView()
        iconView.image = plusIcon
        iconView.frame = CGRect(
            x: tenthOfWidnowWidth * 4,
            y: tenthOfWindowHeight * 8,
            width: tenthOfWidnowWidth * 2,
            height: tenthOfWidnowWidth * 2
        )
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }
    
    private func setupBalanceView() -> UIView {
        let balanceView = UIView()
        let balanceWithLabal = UILabel()
        let balanceTypeLabel = UILabel()
        let balance = UILabel()
        
        
        balanceView.addSubview(balanceWithLabal)
        balanceView.addSubview(balanceTypeLabel)
        balanceView.addSubview(balance)
        // TODO: make the aplication of color to labels as external func
        
//        balanceView.layer.borderColor = UIColor.black.cgColor
//        balanceView.layer.borderWidth = 1
        
        
        // TODO: format string
        balanceWithLabal.text = "in total:"
        balanceWithLabal.textAlignment = .right
        
        balanceTypeLabel.text = "you borrowed"
        balanceTypeLabel.font = balanceTypeLabel.font.withSize(11)
        balanceTypeLabel.textColor = .red
        balanceTypeLabel.textAlignment = .right
        
        balance.text = "3222 usd"
        balance.font = balance.font.withSize(23)
        balance.textColor = .red
        balance.textAlignment = .right
        
        balanceView.frame = CGRect(
            x: tenthOfWidnowWidth * 6,
            y: tenthOfWindowHeight * 8.7,
            width: tenthOfWidnowWidth * 3.3,
            height: tenthOfWidnowWidth * 2
        )
        
        balanceWithLabal.frame = CGRect(
            x: 0,
            y: tenthOfWidnowWidth * 0.2,
            width: tenthOfWidnowWidth * 3,
            height: tenthOfWidnowWidth * 0.5
        )
        
        balanceTypeLabel.frame = CGRect(
            x: 0,
            y: tenthOfWidnowWidth * 0.7,
            width: tenthOfWidnowWidth * 3,
            height: tenthOfWidnowWidth * 0.5
        )
        
        balance.frame = CGRect(
            x: 0,
            y: tenthOfWidnowWidth * 1.2,
            width: tenthOfWidnowWidth * 3,
            height: tenthOfWidnowWidth * 0.5
        )
        
        //balanceWithLabal.superview?.bringSubviewToFront(balanceWithLabal)
        return balanceView
    }
    
    private func setupEventsView() -> UIView {
        let eventsView = UIView()
        let eventName = UILabel()
        let eventLable = UILabel()
        
        eventsView.addSubview(eventName)
        eventsView.addSubview(eventLable)
        
//        eventsView.layer.borderColor = UIColor.black.cgColor
//        eventsView.layer.borderWidth = 1
        
        eventName.text = "ALL"
        eventName.font = UIFont.boldSystemFont(ofSize: 25)
        eventName.textAlignment = .center
        eventName.textColor = .red
        
        eventLable.text = "events"
        eventLable.textAlignment = .center
        
        eventsView.frame = CGRect(
            x: tenthOfWidnowWidth * 0.6,
            y: tenthOfWindowHeight * 8.7,
            width: tenthOfWidnowWidth * 3.3,
            height: tenthOfWidnowWidth * 2
        )
        
        eventName.frame = CGRect(
            x: 0,
            y: tenthOfWidnowWidth * 0.5,
            width: tenthOfWidnowWidth * 3.3,
            height: tenthOfWidnowWidth * 0.5
        )
        
        eventLable.frame = CGRect(
            x: 0,
            y: tenthOfWidnowWidth * 1.2,
            width: tenthOfWidnowWidth * 3.3,
            height: tenthOfWidnowWidth * 0.3
        )
        
        return eventsView
    }
    
}
