//
//  APIRequest.swift
//  Delta
//
//  Created by Nathan FALLET on 26/02/2020.
//  Copyright © 2020 Nathan FALLET. All rights reserved.
//

import Foundation

class APIRequest {
    
    // Object properties
    var method: String
    var path: String
    var access_token: String?
    var queryItems: [URLQueryItem]
    var body: [String: Any]?
    var username: String?
    var password: String?
    
    init(_ method: String, path: String) {
        // Get request parameters
        self.method = method
        self.path = path
        self.queryItems = [URLQueryItem]()
        
        // Get access token if available
        self.access_token = Account.current.access_token
    }
    
    // Add url parameter (String)
    func with(name: String, value: String) -> APIRequest {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }
    
    // Add url parameter (int)
    func with(name: String, value: Int) -> APIRequest {
        return with(name: name, value: "\(value)")
    }
    
    // Add url parameter (int64)
    func with(name: String, value: Int64) -> APIRequest {
        return with(name: name, value: "\(value)")
    }
    
    // Set request body
    func with(body: [String: Any]) -> APIRequest {
        self.body = body
        return self
    }
    
    // Set credentials
    func with(username: String, password: String) -> APIRequest {
        self.username = username
        self.password = password
        return self
    }
    
    // Construct URL
    func getURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.delta-math-helper.com"
        components.path = path
        
        if !queryItems.isEmpty {
            components.queryItems = queryItems
        }
        
        return components.url
    }
    
    // Execute the request
    func execute<T>(_ type: T.Type, completionHandler: @escaping (_ data: T?, _ status: APIResponseStatus) -> ()) where T: Decodable {
        // Check url validity
        if let url = getURL() {
            // Create the request based on give parameters
            var request = URLRequest(url: url)
            request.cachePolicy = URLRequest.CachePolicy.reloadIgnoringLocalCacheData
            request.httpMethod = method
            if let access_token = access_token {
                request.addValue(access_token, forHTTPHeaderField: "access-token")
            }
            if let username = username, let password = password {
                request.addValue(username, forHTTPHeaderField: "username")
                request.addValue(password, forHTTPHeaderField: "password")
            }
            
            // Locale and version information
            if let version = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                request.addValue(version, forHTTPHeaderField: "client-version")
            }
            if Bundle.main.preferredLocalizations.count > 0 {
                request.addValue(Bundle.main.preferredLocalizations[0], forHTTPHeaderField: "Accept-Language")
            }
            
            // Set body
            if let body = body {
                do {
                    request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                } catch let error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completionHandler(nil, .invalidRequest)
                    }
                    return
                }
            }
            
            // Launch the request to server
            URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
                // Check if there is an error
                if let error = error {
                    print(error.localizedDescription)
                    DispatchQueue.main.async {
                        completionHandler(nil, .offline)
                    }
                    return
                }
                
                // Get data and response
                if let data = data, let response = response as? HTTPURLResponse {
                    do {
                        // Parse JSON data
                        let parsed = try JSONDecoder().decode(type, from: data)
                        
                        DispatchQueue.main.async {
                            completionHandler(parsed, self.status(forCode: response.statusCode))
                        }
                    } catch let jsonError {
                        print(jsonError)
                        DispatchQueue.main.async {
                            completionHandler(nil, self.status(forCode: response.statusCode))
                        }
                    }
                } else {
                    // We consider we don't have a valid response
                    DispatchQueue.main.async {
                        completionHandler(nil, .offline)
                    }
                }
            }.resume()
        } else {
            // URL is not valid
            DispatchQueue.main.async {
                completionHandler(nil, .invalidRequest)
            }
        }
    }
    
    // Get status for code
    func status(forCode code: Int) -> APIResponseStatus {
        switch code {
        case 200:
            return .ok
        case 201:
            return .created
        case 400:
            return .invalidRequest
        case 401:
            return .unauthorized
        case 404:
            return .notFound
        default:
            return .offline
        }
    }
    
}
