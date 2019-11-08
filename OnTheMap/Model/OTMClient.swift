//
//  OTMClient.swift
//  OnTheMap
//
//  Created by 🍑 on 04/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation

class OTMClient {
    
    struct Auth {
        static var key = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"
        
        case login
        case logout
        case getStudentLocation(Int)
        case postStudentLocation
        case putStudentLocation(String)
        case getPublicUserData
        
        var urlValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .logout: return Endpoints.base + "session"
            case .getStudentLocation(let limit): return Endpoints.base + "StudentLocation?limit=\(limit)"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "StudentLocation/" + objectId
            case .getPublicUserData: return Endpoints.base + "users/" + Auth.key
            }
        }
        
        var url: URL { return URL(string: urlValue)! }
        
    }
    
    class func login(email: String , password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = "{\"udacity\": {\"username\": \"\(email)\" , \"password\": \"\(password)\"}}".data(using: .utf8)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            let decoder = JSONDecoder()
            do {
                let responseOject = try decoder.decode(PostSession.self, from: newData)
                DispatchQueue.main.async {
                    self.Auth.sessionId = responseOject.session.id
                    self.Auth.key = responseOject.account.key
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
          if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
          request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            DispatchQueue.main.async {
                completion(true, nil)
            }
        }
        task.resume()
    }
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], Error?) -> Void) {
        var request = URLRequest(url: Endpoints.getStudentLocation(100).url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([], error)
                }
                return
            }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(GetStudentLocations.self, from: data)
                DispatchQueue.main.async {
                    completion(responseObject.results, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion([], error)
                }
            }
        }
        task.resume()
    }
    
    
    
    
    
    
}
