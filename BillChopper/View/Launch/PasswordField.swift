import UIKit

class PasswordField: UITextField {
    
    private let visibilityButton: UIButton = {
        let eyeImage = UIImage(systemName: "eye")
        
        
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        button.setImage(eyeImage, for: .normal)
        button.setImage(UIImage(named: "ic_visibility_on"), for: .selected)
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
        rightView = visibilityButton
        rightViewMode = .always
        
        self.returnKeyType = UIReturnKeyType.done
    }
    
    @objc private func showHidePassword(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        self.isSecureTextEntry = !sender.isSelected
    }
    
}
