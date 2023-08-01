import UIKit

class FooterView: UIView {
    
    private let plusIconView: UIImageView = {
        let iconView = UIImageView()
        iconView.image = R.image.plusIcon4()
        iconView.contentMode = .scaleAspectFit
        
        return iconView
    }()
    
    let eventName: UILabel = {
        let lable = UILabel(text: R.string.main.allBig())
        lable.font = UIFont.boldSystemFont(ofSize: 25)
        lable.textAlignment = .center
        lable.textColor = .red
        
        return lable
    }()
    
    let eventText: UILabel = {
        let lable = UILabel(text: R.string.mainFooter.events())
        lable.textAlignment = .center
        lable.textColor = .black
        
        return lable
    }()
    
    private let balanceWithLabal : UILabel = {
        let balanceWithLabal = UILabel()
        balanceWithLabal.text = R.string.mainFooter.inTotal()
        balanceWithLabal.textAlignment = .right
        balanceWithLabal.textColor = .black
        
        return balanceWithLabal
    }()
    
    let balanceTypeLabel: UILabel = {
        let balanceTypeLabel = UILabel()
        balanceTypeLabel.text = R.string.mainCell.youBorrowed()
        balanceTypeLabel.font = balanceTypeLabel.font.withSize(11)
        balanceTypeLabel.textColor = .red
        balanceTypeLabel.textAlignment = .right
        
        return balanceTypeLabel
    }()
    
    let balance: UILabel = {
        let balance = UILabel()
        balance.text = "3222 usd"
        balance.font = balance.font.withSize(23)
        balance.textColor = .red
        balance.textAlignment = .right
        
        return balance
    }()
    
    private let eventContainer = UIView()
    
    private let balanceContainer = UIView()
    
    private lazy var eventStack: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [eventName, eventText])
        stack.axis = .vertical
        stack.distribution = .fill
        
        return stack
    }()
    
    private lazy var balanceStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceWithLabal, balanceTypeLabel, balance])
        stack.axis = .vertical
        stack.distribution = .fill
        
        return stack
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [plusIconView, eventContainer, balanceContainer].forEach({self.addSubview($0)})
        eventContainer.addSubview(eventStack)
        balanceContainer.addSubview(balanceStack)
    }
    
    func addLayer() {
        self.layer.sublayers?.filter{ $0 is CAShapeLayer }.forEach{ $0.removeFromSuperlayer() }
        let shapeLayer = CAShapeLayer()
        self.layer.insertSublayer(shapeLayer, at: 0)

        shapeLayer.strokeColor = UIColor.darkGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 1
        shapeLayer.path = getPath().cgPath
        
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addArc(
            withCenter: CGPoint(x: self.bounds.size.width * 0.5, y: 0),
            radius: 50,
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
    
    override func layoutSubviews() {
        [eventContainer, plusIconView, eventName, eventText, eventStack, balanceContainer, balanceStack,
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        addLayer()
        let constraints: [NSLayoutConstraint] = [
            plusIconView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            plusIconView.centerYAnchor.constraint(equalTo: self.topAnchor),
            plusIconView.widthAnchor.constraint(equalToConstant: 100),
            plusIconView.heightAnchor.constraint(equalToConstant: 100),
            
            eventContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            eventContainer.topAnchor.constraint(equalTo: self.topAnchor),
            eventContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            eventContainer.trailingAnchor.constraint(equalTo: plusIconView.leadingAnchor),
            
            eventStack.centerXAnchor.constraint(equalTo: eventContainer.centerXAnchor),
            eventStack.centerYAnchor.constraint(equalTo: eventContainer.centerYAnchor),
            eventStack.heightAnchor.constraint(equalToConstant: 45),
            
            balanceContainer.leadingAnchor.constraint(equalTo: plusIconView.trailingAnchor),
            balanceContainer.topAnchor.constraint(equalTo: self.topAnchor),
            balanceContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            balanceContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            balanceStack.centerXAnchor.constraint(equalTo: balanceContainer.centerXAnchor),
            balanceStack.centerYAnchor.constraint(equalTo: balanceContainer.centerYAnchor),
            balanceStack.heightAnchor.constraint(equalToConstant: 60),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
}
