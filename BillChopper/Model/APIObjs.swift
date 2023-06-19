import Foundation

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

struct RefreshSuccess: Decodable {
    let access: String
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

struct EventSpend: Decodable {
    let name: String
    let event: Int
    let payeer: UserFetch
    let split: [String: Int8]
    let amount: Int16
    let date: String
}

struct EventsSpends: Decodable {
    let id: Int16
    let name: String
    let participants: [UserFetch]
    let event_type: Int8
    let spends: [EventSpend]
}
