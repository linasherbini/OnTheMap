//
//  OTMClient.swift
//  On The Map
//
//  Created by 🍑 on 08/11/2019.
//  Copyright © 2019 udacity. All rights reserved.
//

import Foundation
import MapKit

class OTMClient {
    
    struct Auth {
        static var firstName = "lina"
        static var lastName = "sherbini"
        static var key = ""
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1/"

        case login
        case logout
        case getStudentLocation
        case postStudentLocation
        case putStudentLocation(String)
        case getPublicUserData(Int)
        var urlValue: String {
            switch self {
            case .login: return Endpoints.base + "session"
            case .logout: return Endpoints.base + "session"
            case .getStudentLocation: return Endpoints.base + "StudentLocation?limit=100&order=-updatedAt"
            case .postStudentLocation: return Endpoints.base + "StudentLocation"
            case .putStudentLocation(let objectId): return Endpoints.base + "StudentLocation/" + objectId
            case .getPublicUserData(let userId): return Endpoints.base + "users/\(userId)"
            }
        }
        
        var url: URL { return URL(string: urlValue)! }
    }
    
    class func login(email: String, password: String, completion: @escaping (Bool, Error?) -> Void){
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
                        print(responseOject)
                        completion(responseOject.account.registered, nil)
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
    
    class func getStudentLocation(completion: @escaping ([StudentLocation], String?, Error?) -> Void) {
        let request = URLRequest(url: Endpoints.getStudentLocation.url)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion([] , error?.localizedDescription, error)
                print(error!)
                return
            }
            do {
                let locationObject = try JSONDecoder().decode(Results.self, from: data)
                completion(locationObject.results, "", nil)
            } catch { completion([],error.localizedDescription, error); print(error) }
        }
        task.resume()
    }
    
    class func postStudentLocation(_ location: StudentLocation, completion: @escaping (String?, Error?) -> Void ) {
        var request = URLRequest(url: Endpoints.postStudentLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let studentLocation = StudentLocation(objectId: Auth.sessionId, uniqueKey: Auth.key, firstName: Auth.firstName, lastName: Auth.lastName, mapString: location.mapString, mediaURL: location.mediaURL, latitude: location.latitude, longitude: location.longitude)
        let body = try! JSONEncoder().encode(studentLocation)
        request.httpBody = body
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var message: String?
            if error != nil {
                message = error?.localizedDescription
                completion(message,error)
                return
            }
            if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode >= 200 && statusCode < 300 {
                    message = "Data was added successfully"
                }
                if statusCode >= 400 {
                    message = "Unable to post location"
                }
            } else {
                message = "Internet connection error"
            }
            DispatchQueue.main.async {
                completion(message, nil)
                print(message!)
                print(data!)
            }
        }
        task.resume()
    }
    
    }
    
    

