protocol EventUserProtocol {
    var username: String { get }
    var percent: Int? { get set }
    var imageName: String? { get set }
    var phone: String { get }
}
// probably i'm gonna need event parrent for the spend

protocol newEvenUserProtocol {
    var username: String? { get set }
    var phone: String { get }
    var imageName: String? { get set }
}

protocol EventProtocol {
    var eventType: String { get }
    var name: String { get }
    var users: [EventUserProtocol] { get }
}

struct EventUser: EventUserProtocol {
    let username: String
    var percent: Int?
    var imageName: String?
    let phone: String
}

struct newEventUser: newEvenUserProtocol {
    var username: String?
    let phone: String
    var imageName: String?
}

struct spendEvent: EventProtocol {
    let eventType: String
    let name: String
    let users: [EventUserProtocol]
}

