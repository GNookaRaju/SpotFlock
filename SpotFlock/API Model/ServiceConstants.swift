//
//  ServiceConstants.swift
//  SpotFlock
//
//  Created by SpotFlock on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import Foundation

enum Environment {
    
    case development
    case staging
    case production
    
    
    func baseURL() -> String {
        return "\(urlProtocol())://\(domain())\(route())"
    }
    
    func urlProtocol() -> String {
        switch self {
        case .staging, .production:
            return "https"
        default:
            return "https"
        }
    }
    
    func domain() -> String {
        switch self {
        case .development:
            return "gospark.app"
        case .staging, .production:
            return "gospark.app"
        }
    }
    
    func route() -> String {
        return "/api/v1"
    }
    
}

extension Environment {
    func host() -> String {
        return "\(self.domain())"
    }
}


// MARK:- APIs

#if DEBUG
let environment: Environment = Environment.development
#else
let environment: Environment = Environment.staging
#endif

let baseUrl = environment.baseURL()

struct Path {    
    var registration: String { return "\(baseUrl)/register" }
    
    var login: String { return "\(baseUrl)/login" }
    
    var newFeed: String { return "\(baseUrl)/kstream" }
}
