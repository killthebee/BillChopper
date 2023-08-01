enum Urls: String {
    case dummy = "http://127.0.0.1:8000/api/user/dummy/"
    case register = "http://127.0.0.1:8000/api/user/register/"
    case login = "http://127.0.0.1:8000/api/token/"
    case refresh = "http://127.0.0.1:8000/api/token/refresh/"
    case image = "http://127.0.0.1:8000/api/user/update_image/"
    case updateUser = "http://127.0.0.1:8000/api/user/update_user/"
    case fetchUserData = "http://127.0.0.1:8000/api/user/fetch_user_info/"
    case createEvent = "http://127.0.0.1:8000/api/user/create_event/"
    case createSpend = "http://127.0.0.1:8000/api/user/create_spend/"
    case fetchEventsSpends = "http://127.0.0.1:8000/api/user/fetch_events_spends/"
    case deleteSpend = "http://127.0.0.1:8000/api/user/delete_spend/"
}

enum Method: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum ContentType: String {
    case json = "application/json"
    case form = "application/x-www-form-urlencoded"
}
