import UIKit


class PhoneInputDelegate: NSObject {
    
    var rawNumber = ""
    
}

extension PhoneInputDelegate: UITextFieldDelegate {
    
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