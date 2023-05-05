import UIKit

enum Urls: String {
    case dummy = "http://127.0.0.1:8000/api/user/dummy/"
}

enum Method: String {
    case post = "POST"
}


enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
