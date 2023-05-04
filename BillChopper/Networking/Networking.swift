import UIKit

class Networking {
    // I think it'll grow
    
}


func setupRequest(
    url: Urls, method: Method, contertType: ContentType = .json, body: Data? = nil
) -> URLRequest {
    var request = URLRequest(url: URL(string: url.rawValue)!)
    request.httpMethod = method.rawValue
    request.setValue(contertType.rawValue, forHTTPHeaderField: "Content-Type")
    if body != nil {
        request.httpBody = body
    }
    
    return request
}

func performRequest(
    request: URLRequest, handler: @escaping (DummyData) -> ()
) {
    let tast = URLSession.shared.dataTask(with: request) { data, response, error in
        guard
            let data = data,
            let response = response as? HTTPURLResponse,
            error == nil
        else {                                                               // check for fundamental networking error
            print("error", error ?? URLError(.badServerResponse))
            return
        }
        guard (200 ... 299) ~= response.statusCode else {                    // check for http errors
            print("statusCode should be 2xx, but is \(response.statusCode)")
            print("response = \(response)")
            return
        }
        do {
            let responseObject = try JSONDecoder().decode(DummyData.self, from: data)
            print(responseObject)
            handler(responseObject)
        } catch {
            print(error) // parsing error

            if let responseString = String(data: data, encoding: .utf8) {
                print("responseString = \(responseString)")
            } else {
                print("unable to parse response as string")
            }
        }
    }
    
    tast.resume()
}
