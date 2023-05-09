struct DummyData: Decodable {
    let task_id: String
    let Success: Bool
    let hi_to: String
}

struct RegisterationSuccess: Decodable {
    let username: String
    let first_name: String
}

struct RegisterError: Decodable {
    let username: [String]?
    let password: [String]?
}


struct LoginSuccess: Decodable {
    let access: String
    let refresh: String
}


struct LoginError: Decodable {
    let detail: String
}
