import UIKit

class PasswordAndPassword: UIView {
    
    private let passwordLable = UILabel(text: R.string.launchView.passwordText())
    private let repeatPasswordLable = UILabel(text: R.string.launchView.repeatPasswordText())
    
    let passwordInput = PasswordField()
    
    let repeatPasswordInput = PasswordField()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        passwordInput.textContentType = .oneTimeCode
        repeatPasswordInput.textContentType = .oneTimeCode
        addSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        [repeatPwStack, pwStack].forEach({addSubview($0)})
    }
    
    private lazy var pwStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [passwordLable, passwordInput]
        )
        passwordInput.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.65).isActive = true
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    private lazy var repeatPwStack: UIStackView = {
        let stack = UIStackView(
            arrangedSubviews: [repeatPasswordLable, repeatPasswordInput]
        )
        repeatPasswordInput.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.65).isActive = true
        stack.distribution = .fill
        stack.spacing = 10
        
        return stack
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [pwStack, repeatPwStack, passwordInput, repeatPasswordInput
        ].forEach({$0.translatesAutoresizingMaskIntoConstraints = false})
        
        let constraints: [NSLayoutConstraint] = [
            pwStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            pwStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            pwStack.topAnchor.constraint(equalTo: topAnchor),
            pwStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
            
            repeatPwStack.bottomAnchor.constraint(equalTo: bottomAnchor),
            repeatPwStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 14),
            repeatPwStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -14),
            repeatPwStack.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5),
        ]
        
        NSLayoutConstraint.activate(constraints)
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
