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
    
    func stripPhoneNumber(phone: String) -> String {
        var phone = phone
        let chars: Set<Character> = ["+", "(", ")", " "]
        phone.removeAll(where: { chars.contains($0) })
        
        return phone
    }
    
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }
    
    private func isValidUsername(username: String) -> Bool {
        let usernameRegex = "\\A\\w{1,18}\\z"
        let usernameTest = NSPredicate(format: "SELF MATCHES %@", usernameRegex)
        return usernameTest.evaluate(with:username)
    }
    
    func isValidEventName(eventName: String) -> Bool {
        let eventNameRegex = "^.{3,30}$"
        let eventNameTest = NSPredicate(format: "SELF MATCHES %@", eventNameRegex)
        return eventNameTest.evaluate(with:eventName)
    }
    
    func isAmountValid(amount: String) -> Bool {
        let amountRegex = "^[0-9]{1,7}$"
        let amountTest = NSPredicate(format: "SELF MATCHES %@", amountRegex)
        return amountTest.evaluate(with:amount)
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
            serializedData["username"] = cleanPhone
        } else {
            isValid = false
            errors["phone"] = "phone isn't valid"
        }
        
        if isValidUsername(username: username) {
            serializedData["first_name"] = username
        } else {
            isValid = false
            errors["username"] = "username isn't valid"
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func verifySingIn(username: String?, password: String?) -> (Bool, [String: String]) {
        guard username != nil, password != nil else {
            return (false, ["errors": "No password or phone provided!"])
        }
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        
        let cleanPhone = stripPhoneNumber(phone: username!)
        if isValidPhone(phone: cleanPhone) {
            serializedData["username"] = cleanPhone
        } else {
            isValid = false
            errors["errors", default: ""] += "phone isn't valid "
        }
        
        let pwVerificationResult = verifyPassword(password: password!)
        if pwVerificationResult != "" {
            isValid = false
            errors["errors", default: ""] += "password isn't valid"
        } else {
            serializedData["password"] = password
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func verifyUserUpdate(username: String?, gender: String?, phone: String) -> (Bool, [String: String]) {
        guard let username = username else {
            return (false, ["username": "username field is empty"])
        }
        guard let gender = gender else {
            return (false, ["gender": "gender hasn't been chosen"])
        }
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        serializedData["is_male"] = gender == "male" ? "True" : "False"
        // TODO: seens each class instanst used with one veirfier i might consider movind this into class atribs
        let cleanPhone = stripPhoneNumber(phone: phone)
        if isValidPhone(phone: cleanPhone) {
            serializedData["username"] = cleanPhone
        } else {
            isValid = false
            errors["phone"] = "phone isn't valid"
        }
        
        if isValidUsername(username: username) {
            serializedData["first_name"] = username
        } else {
            isValid = false
            errors["username"] = "username isn't valid"
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
}
