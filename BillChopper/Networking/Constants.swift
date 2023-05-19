enum Urls: String {
    case dummy = "http://127.0.0.1:8000/api/user/dummy/"
    case register = "http://127.0.0.1:8000/api/user/register/"
    case login = "http://127.0.0.1:8000/api/token/"
    case image = "http://127.0.0.1:8000/api/user/update_image/"
    case updateUser = "http://127.0.0.1:8000/api/user/update_user/"
    case fetchUserData = "http://127.0.0.1:8000/api/user/fetch_user_info/"
    case createEvent = "http://127.0.0.1:8000/api/user/create_event/"
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
}

enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
