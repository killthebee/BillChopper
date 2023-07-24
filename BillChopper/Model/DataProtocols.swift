import Foundation
import UIKit

protocol EventUserProtocol {
    var username: String { get }
    var percent: Int { get set }
    var image: UIImage? { get set }
    var phone: String { get }
}
// probably i'm gonna need event parrent for the spend

protocol newEventUserProtocol {
    var username: String? { get set }
    var imageUrl: String? { get set }
    var phone: String { get }
}

protocol EventProtocol {
    var eventType: String { get }
    var name: String { get }
    var users: [EventUserProtocol] { get }
}

protocol EventButtonDataProtocol {
    var id: Int16 { get }
    var name: String { get }
    var eventType: Int8 { get }
}

protocol UsersButtonDataProtocol {
    var username: String { get }
    var imageName: String { get set }
}

protocol SpendDataProtocol {
    var spendName: String { get }
    var payeerName: String { get }
    var amount: Int16 { get set }
    var isBorrowed: Bool { get set }
    var totalAmount: Int16 { get set }
    var date: Date { get }
}

struct EventUser: EventUserProtocol {
    let username: String
    var percent: Int
    var image: UIImage?
    let phone: String
}

struct newEventUser: newEventUserProtocol {
    var username: String?
    let phone: String
    var imageUrl: String?
}

struct spendEvent: EventProtocol {
    let eventType: String
    let name: String
    let users: [EventUserProtocol]
}

struct EventButtonData: EventButtonDataProtocol {
    let id: Int16
    let name: String
    let eventType: Int8
}

struct UsersButtonData: UsersButtonDataProtocol {
    let username: String
    var imageName: String
}

struct SpendData: SpendDataProtocol {
    let spendName: String
    let payeerName: String
    var amount: Int16
    var isBorrowed: Bool
    var totalAmount: Int16
    let date: Date
}
