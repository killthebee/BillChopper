import Foundation

class Verifier {
    private func verifyPassword(password: String) -> String {
        
        var errors = ""
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[A-Z]+.*").evaluate(with: password)){
            errors += R.string.verifiers.noUpperCase()
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[0-9]+.*").evaluate(with: password)){
            errors += R.string.verifiers.noDigits()
        }
        
        if(!NSPredicate(format:"SELF MATCHES %@", ".*[a-z]+.*").evaluate(with: password)){
            errors += R.string.verifiers.noLowerCase()
        }
        
        if(password.count < 8){
            errors += R.string.verifiers.min8()
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
        let phoneRegex = "^[0-9+]{1,3}+[0-9]{8,16}$"
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
            errors["password"] = R.string.verifiers.pwNotMatches()
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
            errors["phone"] = R.string.verifiers.phonesNotValid()
        }
        
        if isValidUsername(username: username) {
            serializedData["first_name"] = username
        } else {
            isValid = false
            errors["username"] = R.string.verifiers.usernamesNotValid()
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func verifySingIn(username: String?, password: String?) -> (Bool, [String: String]) {
        guard username != nil, password != nil else {
            return (false, ["errors": R.string.verifiers.pwOrUsernameNotValid()])
        }
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        
        let cleanPhone = stripPhoneNumber(phone: username!)
        if isValidPhone(phone: cleanPhone) {
            serializedData["username"] = cleanPhone
        } else {
            isValid = false
            errors["errors", default: ""] += R.string.verifiers.phonesNotValid() + " "
        }
        
        let pwVerificationResult = verifyPassword(password: password!)
        if pwVerificationResult != "" {
            isValid = false
            errors["errors", default: ""] += R.string.verifiers.pwNotMatches()
        } else {
            serializedData["password"] = password
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func verifyUserUpdate(username: String?, gender: String?, phone: String) -> (Bool, [String: String]) {
        guard let username = username else {
            return (false, ["username": R.string.verifiers.usernameIsEmpty()])
        }
        guard let gender = gender else {
            return (false, ["gender": R.string.verifiers.genderNotSelected()])
        }
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        serializedData["is_male"] = gender == "male" ? "True" : "False"
        // TODO: seens each class instans is used with one veirfier i might consider moving this into class atribs
        let cleanPhone = stripPhoneNumber(phone: phone)
        if isValidPhone(phone: cleanPhone) {
            serializedData["username"] = cleanPhone
        } else {
            isValid = false
            errors["phone"] = R.string.verifiers.phonesNotValid()
        }
        
        if isValidUsername(username: username) {
            serializedData["first_name"] = username
        } else {
            isValid = false
            errors["username"] = R.string.verifiers.usernamesNotValid()
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func validateNewSpend(
        _ name: String?,
        _ amount: String?,
        _ splitPecents: Int
    )  -> (isValied: Bool, data: [String: String] ) {
        var isValid = true
        var errors: [String: String] = [:]
        var serializedData: [String: String] = [:]
        if name == nil {
            isValid = false
            errors["name"] = R.string.verifiers.spendNameEmpty()
        } else {
            if isValidEventName(eventName: name!) {
                serializedData["name"] = name!
            } else {
                isValid = false
                errors["name"] = R.string.verifiers.spendNameNotValid()
            }
            
        }
        
        if amount == nil {
            isValid = false
            errors["amount"] = R.string.verifiers.amountEmpty()
        } else {
            if isAmountValid(amount: amount!) {
                serializedData["amount"] = amount!
            } else {
                isValid = false
                errors["amount"] = R.string.verifiers.amountNotValid()
            }
        }
        
        if !isSplitValid(splitPecents) {
            isValid = false
            errors["split"] = "error"
        }
        
        return isValid ? (isValid, serializedData) : (isValid, errors)
    }
    
    func UsersAreAdded(users: [newEventUserProtocol]) -> Bool {
        return users.count > 0 
    }
    
    func isSplitValid(_ sum: Int) -> Bool {
        return !(99 > sum || 100 < sum)
    }
}
