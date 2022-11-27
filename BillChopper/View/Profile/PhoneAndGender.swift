import UIKit


class PhoneAndGender: UIView {
    
    let phoneTextLable = UILabel()
    let genderTextLable = UILabel()
    
    let phoneInput = UITextField()
    let codeInput = UITextField()
    
    var numberFormated = ""
    var rawNumber = ""
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor(
            hue: 0/360, saturation: 0/100, brightness: 98/100, alpha: 1.0
        )
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 15
        
        
        phoneTextLable.text = "phone:"
        genderTextLable.text = "gender:"
        self.addSubview(phoneTextLable)
        setUpPhoneInput()
        self.addSubview(phoneInput)
        setUpCodeInput()
        self.addSubview(codeInput)
        self.addSubview(genderTextLable)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        addLayer()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        phoneTextLable.frame = CGRect(
            x: self.bounds.size.width * 0.03,
            y: 0,
            width: self.bounds.size.width * 0.3,
            height: self.bounds.size.height * 0.5
        )
        phoneInput.frame = CGRect(
            x: self.bounds.size.width * 0.47,
            y: 0,
            width: self.bounds.size.width * 0.6,
            height: self.bounds.size.height * 0.5
        )
        codeInput.frame = CGRect(
            x: self.bounds.size.width * 0.27,
            y: 0,
            width: self.bounds.size.width * 0.18,
            height: self.bounds.size.height * 0.5
        )
        genderTextLable.frame = CGRect(
            x: self.bounds.size.width * 0.03,
            y: self.bounds.size.height * 0.5,
            width: self.bounds.size.width * 0.3,
            height: self.bounds.size.height * 0.5
        )
    }
    
    private func setUpPhoneInput() {
        //phoneInput.text = "(000) 000 00 00"
        phoneInput.placeholder = "(999) 111 11 11"
        phoneInput.font = UIFont.boldSystemFont(ofSize: 19)
        phoneInput.autocorrectionType = UITextAutocorrectionType.no
        phoneInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        phoneInput.keyboardType = UIKeyboardType.namePhonePad
        phoneInput.returnKeyType = UIReturnKeyType.done
        phoneInput.delegate = self
        phoneInput.tag = 1
    }
    
    private func setUpCodeInput() {
        //codeInput.text = "+7"
        codeInput.placeholder = "+7"
        codeInput.font = UIFont.boldSystemFont(ofSize: 19)
        codeInput.autocorrectionType = UITextAutocorrectionType.no
        codeInput.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
        codeInput.keyboardType = UIKeyboardType.namePhonePad
        codeInput.returnKeyType = UIReturnKeyType.done
        codeInput.delegate = self
        codeInput.textAlignment = .right
        codeInput.tag = 0
    }
    
    private func addLayer() {
        let middleLineLayer = CAShapeLayer()
        let betweenPhoneNumberLineLayer = CAShapeLayer()
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


extension PhoneAndGender: UITextFieldDelegate {

        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            switch textField.tag {
            case 0:
                if textField.text!.count == 0 && string != "+"{
                    textField.text = "+"
                }
                if textField.text!.count == 4 && range.length == 0{
                    return false
                }
                if range.length != 0 && textField.text!.count - 1 == range.length{
                    textField.text = nil
                    return false
                }
                return true
            case 1:
                if range.lowerBound == 15{
                    return false
                }
                rawNumber = getNewRawNumber(from: rawNumber, range: range, num: string)
                textField.text = getNewNumberText(from: rawNumber, range: range, num: string)
            default:
                break
            }
            return false
        }

}
