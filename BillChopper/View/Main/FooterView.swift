import UIKit

final class FooterView: UIView {
    // TODO: I must have forgotten to refctor this
    override var frame: CGRect { didSet { setupView() }}
    
    private func setupView() {
        addLayer()
        
        let plusIconView = setupPlusIconView()
        let balanceView = setupBalanceView()
        let eventsView = setupEventsView()
        
        self.addSubview(plusIconView)
        self.addSubview(balanceView)
        self.addSubview(eventsView)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
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
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 0.4, y: 0))
        path.addArc(
            withCenter: CGPoint(x: self.bounds.size.width * 0.5, y: 0),
            radius: self.bounds.size.width * 0.1,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: 0))
        path.addLine(to: CGPoint(x: self.bounds.size.width, y: self.bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: self.bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: 0))
        path.close()
        return path
    }
    
    private func setupPlusIconView() -> UIImageView {
        let iconView = UIImageView()
        iconView.image = R.image.plusIcon()
        iconView.frame = CGRect(
            x: self.bounds.size.width * 0.4,
            y: self.bounds.size.height * -0.33,
            width: self.bounds.size.width * 0.2,
            height: self.bounds.size.width * 0.2
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
        // TODO: make aplication of color to labels as an external func
        
//        balanceView.layer.borderColor = UIColor.black.cgColor
//        balanceView.layer.borderWidth = 1
        
        
        // TODO: format string
        balanceWithLabal.text = R.string.mainFooter.inTotal()
        balanceWithLabal.textAlignment = .right
        balanceWithLabal.textColor = .black
        
        balanceTypeLabel.text = R.string.mainCell.youBorrowed()
        balanceTypeLabel.font = balanceTypeLabel.font.withSize(11)
        balanceTypeLabel.textColor = .red
        balanceTypeLabel.textAlignment = .right
        
        balance.text = "3222 usd"
        balance.font = balance.font.withSize(23)
        balance.textColor = .red
        balance.textAlignment = .right
        
        balanceView.frame = CGRect(
            x: self.frame.size.width * 0.6,
            y: self.frame.size.height * 0.13,
            width: self.frame.size.width * 0.3,
            height: self.frame.size.width * 0.2
        )
        balanceWithLabal.frame = CGRect(
            x: 0,
            y: self.frame.size.height * 0.06,
            width: self.frame.size.width * 0.3,
            height: self.frame.size.width * 0.05
        )
        
        balanceTypeLabel.frame = CGRect(
            x: 0,
            y: self.frame.size.height * 0.22,
            width: self.frame.size.width * 0.3,
            height: self.frame.size.width * 0.05
        )
        
        balance.frame = CGRect(
            x: 0,
            y: self.frame.size.height * 0.35,
            width: self.frame.size.width * 0.3,
            height: self.frame.size.width * 0.05
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
        
        eventLable.text = R.string.mainFooter.events()
        eventLable.textAlignment = .center
        eventLable.textColor = .black
        
        eventsView.frame = CGRect(
            x: self.frame.size.width * 0.06,
            y: self.frame.size.height * 0.13,
            width: self.frame.size.width * 0.3,
            height: self.frame.size.width * 0.2
        )
        
        eventName.frame = CGRect(
            x: 0,
            y: self.frame.size.width * 0.05,
            width: self.frame.size.width * 0.32,
            height: self.frame.size.width * 0.08
        )
        
        eventLable.frame = CGRect(
            x: 0,
            y: self.frame.size.width * 0.12,
            width: self.frame.size.width * 0.33,
            height: self.frame.size.width * 0.04
        )
        
        return eventsView
    }
    
}
