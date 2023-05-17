protocol EventUserProtocol {
    var username: String { get }
    var percent: Int? { get set }
    var imageName: String? { get set }
}
// probably i'm gonna need event parrent for the spend 


struct EventUser: EventUserProtocol {
    let username: String
    var percent: Int?
    var imageName: String?
}
