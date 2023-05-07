struct DummyData: Decodable {
    let task_id: String
    let Success: Bool
    let hi_to: String
}

struct RegisterError: Decodable {
    let username: [String]?
    let password: [String]?
}
