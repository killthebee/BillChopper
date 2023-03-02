import UIKit

class PhoneAndPassword: UIView {
    
    private let phoneLable = UILabel(text: R.string.profileView.phoneText())
    
    private let passwordLable = UILabel(text: R.string.launchView.passwordText())
    
    let codeInput = PhoneInput(isCode: true)
    
    let phoneInput = PhoneInput(isCode: false)
    
    let phoneNumDelegate = PhoneInputDelegate()
    
    let passwordInput = PasswordField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [phoneStack, pwStack].forEach({addSubview($0)})
    }
    
    private func setupViews() {
        phoneInput.delegate = phoneNumDelegate
        codeInput.delegate = phoneNumDelegate
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        addLayer()
    }
    
    // MAKR: layout
    
    private lazy var phoneStack: UIStackView = {
        // TODO: DRY it
        let stack = UIStackView(
            arrangedSubviews: [phoneLable, codeInput, phoneInput]
        )
        stack.distribution = .fill
        stack.spacing = 10
        stack.setCustomSpacing(5, after: stack.arrangedSubviews[1])
        
        return stack
    }()
    
    private lazy var pwStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [passwordLable, passwordInput]
        )
        passwordInput.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.55).isActive = true
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [phoneStack, pwStack, passwordInput].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let constraints: [NSLayoutConstraint] = [
            phoneStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            phoneStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            phoneStack.topAnchor.constraint(equalTo: topAnchor),
            phoneStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            pwStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            pwStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            pwStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            pwStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
        ]
        
        NSLayoutConstraint.activate(constraints)
    }
    
    private func addLayer() {
        let middleLineLayer = CAShapeLayer()
        self.layer.addSublayer(middleLineLayer)
        
        middleLineLayer.strokeColor = UIColor.darkGray.cgColor
        middleLineLayer.fillColor = UIColor.white.cgColor
        middleLineLayer.lineWidth = 1
        middleLineLayer.path = getPath().cgPath
    }
    
    private func getPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(
            x: self.bounds.size.width * 0.03, y: self.bounds.size.height * 0.5
        ))
        path.addLine(to: CGPoint(x: self.bounds.size.width * 0.97, y: self.bounds.size.height * 0.5))
        path.close()
        
        return path
    }
}
