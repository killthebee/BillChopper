import UIKit

class PasswordField: UITextField {
    
    private let visibilityButton: UIButton = {
        let button = UIButton()
        button.setImage(R.image.pwHidden(), for: .normal)
        button.setImage(R.image.pwShown(), for: .selected)
        button.imageView?.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(showHidePassword(_:)), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setup() {
        self.isSecureTextEntry = true
        visibilityButton.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        rightView = visibilityButton
        rightViewMode = .always
        
        self.returnKeyType = UIReturnKeyType.done
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        return .init(x:bounds.width - 29, y: 5, width: 30, height: 30)
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}
