import UIKit

class PhoneInput: UITextField {
    
    required init(isCode: Bool) {
        super.init(frame: .zero)
        self.attributedPlaceholder = NSAttributedString(
            string: isCode ? "7" : "(999) 111 11 11",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray]
        )
        self.textColor = .black
        self.font = UIFont.boldSystemFont(ofSize: 19)
        self.autocorrectionType = UITextAutocorrectionType.no
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        self.keyboardType = UIKeyboardType.phonePad
        self.returnKeyType = UIReturnKeyType.done
        if isCode { self.textAlignment = .right }
        self.tag = isCode ? 0 : 1
        }

    required override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
