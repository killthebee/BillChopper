import UIKit

class Networking {
    // I think it'll grow
    
}

func setupRequest(
    url: Urls,
    method: Method,
    contertType: ContentType = .json,
    body: Data? = nil
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
    request: URLRequest,
    successHandler: @escaping (Data) throws -> (),
    failureHandler: @escaping (Data) throws -> () = { _ in }
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
            do {
                try failureHandler(data)
            } catch {
                print(error) // parsing error
                
                if let responseString = String(data: data, encoding: .utf8) {
                    print("responseString = \(responseString)")
                } else {
                    print("unable to parse response as string")
                }
            }
            return
        }
        do {
            try successHandler(data)
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

func uploadImage(fileName: String, image: UIImage) {
    let url = URL(string: Urls.image.rawValue)
    let tokenData = KeychainHelper.standard.read(service: "access-token", account: "backend-auth")!
    let accessToken = String(data: tokenData, encoding: .utf8)!

    let boundary = UUID().uuidString

    let session = URLSession.shared

    var urlRequest = URLRequest(url: url!)
    urlRequest.httpMethod = "POST"

    urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    urlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    
    var data = Data()

    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
    data.append("Content-Disposition: form-data; name=\"profile_image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
    data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
    data.append(image.pngData()!)

    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

    session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
        if error == nil {
            let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
            if let json = jsonData as? [String: Any] {
                print(json)
            }
        }
    }).resume()
}
