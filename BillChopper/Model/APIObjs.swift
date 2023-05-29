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

struct userFetchError: Decodable {
    let detail: String
}

struct Profile: Decodable {
    let is_male: Bool
    let profile_image: String?
}

struct UserFetch: Decodable {
    let first_name: String
    let username: String
    let profile: Profile
}

struct CreateSpendResponse: Decodable {
    let success: Bool
}
