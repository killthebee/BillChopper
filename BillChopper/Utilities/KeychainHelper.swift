import Foundation

final class KeychainHelper {
    
    static let standard = KeychainHelper()
    private init() {}
    
    func save(_ data: Data, serice: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serice,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            update(
                data,
                serice: "access-token",
                account: "backend-auth"
            )
            
            return
        }
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    
    private func update(_ data: Data, serice: String, account: String) {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serice,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        let attributesToUpdate = [kSecValueData, data] as! CFDictionary
        
        let status = SecItemUpdate(query, attributesToUpdate)
        
        if status != errSecSuccess {
            print("Error: \(status)")
        }
    }
    
    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
    
    func readToken(service: String, account: String) -> String {
        // TODO: mb make it a bit more optional?
        let data = read(service: service, account: account)!
        let accessToken = String(data: data, encoding: .utf8)!
        return accessToken
    }
}
