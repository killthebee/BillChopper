import UIKit


class PhoneInputDelegate: NSObject {
    
    var rawNumber = ""
    var continueButton: UIBarButtonItem? = nil
}

extension PhoneInputDelegate: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField.tag {
        case 0:
            continueButton?.tintColor = customGreen
            if textField.text!.count == 0 && string != "+"{
                textField.text = "+"
            }
            if textField.text!.count == 4 && range.length == 0{
                return false
            }
            if range.length != 0 && textField.text!.count - 1 == range.length{
                textField.text = nil
                continueButton?.tintColor = .systemGray
                return false
            }
            return true
        case 1:
            if range.lowerBound == 15{
                return false
            }
            let phoneConverter = PhoneConverter(oldRawNumber: rawNumber, range: range, num: string)
            rawNumber = phoneConverter.getNewRawNumber()
            textField.text = phoneConverter.newNumber
        default:
            break
        }
        return false
    }
    
}
