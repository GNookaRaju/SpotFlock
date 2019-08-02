//
//  APIController.swift
//  SpotFlock
//
//  Created by SpotFlock on 30/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//


import UIKit


class APIController: NSObject, URLSessionDelegate {
    var apiToken: String?
    var userInfo: User?
    var newsFeedList: [Feed]?
    private let session = URLSession.shared
    
    private override init() {
        
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        completionHandler(URLSession.AuthChallengeDisposition.useCredential, URLCredential(trust: challenge.protectionSpace.serverTrust!))
    }

    static let sharedInstance = APIController()
    
    func logoutApp() -> Void {
        apiToken = nil
        userInfo = nil
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "api_token")
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "email")
        let _: Bool = KeychainWrapper.standard.removeObject(forKey: "password")
        session.finishTasksAndInvalidate()
    }
    
    typealias loginCompletion = (Bool, Any?) -> ()
    func login(userEmail: String, userPassword: String, completion: @escaping loginCompletion) -> Void {
        let urlString = Path().login
        let userInfo: [String: String] = ["email": userEmail, "password": userPassword]
        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        do {
            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
            request.httpBody = jsonData
        } catch {
            print(error.localizedDescription)
            completion(false, error.localizedDescription)
        }
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            
            guard data != nil else {
                print("Error: No data to decode")
                completion(false, nil)
                return
            }
            
            guard let responseDetails = try? JSONDecoder().decode(ResponseDetails.self, from: data!)  else {
                completion(false, nil)
                return
            }
            if responseDetails.status ?? "" == "true" {
                if let user: User = responseDetails.user {
                    self.userInfo = user
                    let _: Bool = KeychainWrapper.standard.set(user.apiToken, forKey: "api_token")
                    let _: Bool = KeychainWrapper.standard.set(userEmail, forKey: "email")
                    let _: Bool = KeychainWrapper.standard.set(userPassword, forKey: "password")
                    self.apiToken = user.apiToken
                }
            }
            completion(true, responseDetails)
        })
        dataTask.resume()
    }
    
    typealias registerComplition = (Bool, Any?) -> ()
    func registerNewUser(userInfo: [String: String], completion: @escaping registerComplition) -> Void {
        let urlString = Path().registration

        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url: requestUrl, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
//        do {
//            let jsonData = try JSONSerialization.data(withJSONObject: userInfo, options: .prettyPrinted)
//            request.httpBody = jsonData
//        } catch {
//            print(error.localizedDescription)
//            completion(false, error.localizedDescription)
//        }
        set(userInfo, urlRequest: &request)
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard data != nil else {
                print("Error: No data to decode")
                completion(false, nil)
                return
            }
            
            guard let responseDetails = try? JSONDecoder().decode(ResponseDetails.self, from: data!)  else {
                completion(false, nil)
                return
            }
            completion(true, responseDetails)
        })
        dataTask.resume()
    }
        
    
    typealias gettingNewsFeedCompletion = (Any?) -> ()
    func gettingNewsFeedList(completion: @escaping gettingNewsFeedCompletion) -> Void {
        if let feeds: [Feed] = self.newsFeedList {
            completion(feeds)
            return
        }
        let urlString = Path().newFeed
        
        guard let requestUrl = URL(string:urlString) else { return }
        var request = URLRequest(url:requestUrl)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        if let token: String = self.apiToken {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            completion(nil)
            return
        }
        request.timeoutInterval = 10;
        
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            guard let data = data else {
                print("Error: No data to decode")
                completion(nil)
                return
            }
//            print("\(String.init(data: data, encoding: .utf8))")
            guard let kStream = try? JSONDecoder().decode(Kstream.self, from: data)  else {
                print("Error: Couldn't decode data into Categories")
                completion(nil)
                return
            }
            if kStream.success == true {
                if let ksclass: KstreamClass = kStream.kstream {
                    if let feeds: [Feed] = ksclass.feed {
                        self.newsFeedList = feeds
                        completion(feeds)
                    }
                }
            }
            completion(nil)
            return
        })
        dataTask.resume()
    }
    
    func set(_ parameters: [String: Any], urlRequest: inout URLRequest) {
        if parameters.count != 0 {
            if let jsonData = try? JSONSerialization.data(withJSONObject: parameters, options: []) {
                urlRequest.httpBody = jsonData
            }
        }
    }
    
}
