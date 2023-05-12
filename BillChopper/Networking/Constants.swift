enum Urls: String {
    case dummy = "http://127.0.0.1:8000/api/user/dummy/"
    case register = "http://127.0.0.1:8000/api/user/register/"
    case login = "http://127.0.0.1:8000/api/token/"
    case image = "http://127.0.0.1:8000/api/user/update_image/"
}

enum Method: String {
    case post = "POST"
}


enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
