import Foundation

class Verifier {
    private func verifyPassword(password: String) -> String {
        
        var errors = ""
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)){
            errors += "least one uppercase, "
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)){
            errors += "least one digit, "
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)){
            errors += "least one lowercase, "
        }
        
        if(password.count < 8){
            errors += "min 8 characters total"
        }
        return errors
    }
    
    private func stripPhoneNumber(phone: String) -> String {
        var phone = phone
        let chars: Set<Character> = ["+", "(", ")", " "]
        phone.removeAll(where: { chars.contains($0) })
        
        return phone
    }
    
    private func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    private func isValidUsername(username: String) -> Bool {
        let usernameRegex = "\\A\\w{1,18}\\z"
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with:username)
    }
    
    func verifyUserSignUpData (
        username: String, password: String, secondPassword: String, phone: String
    ) -> (Bool, [String: String]) {
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        
        if password != secondPassword {
            errors["password"] = "Passwords doesn't match"
            return (false, errors)
        }
        
        let pwVerificationResult = verifyPassword(password: password)
        if pwVerificationResult != "" {
            isValid = false
            errors["password"] = pwVerificationResult
        } else {
            serializedData["password"] = password
        }
        
        let cleanPhone = stripPhoneNumber(phone: phone)
        if isValidPhone(phone: cleanPhone) {
            serializedData["phone"] = cleanPhone
        } else {
            isValid = false
            errors["phone"] = "phone isn't valid"
        }
        
        if isValidUsername(username: username) {
            serializedData["username"] = username
        } else {
            isValid = false
            errors["username"] = "username isn't valid"
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
}
