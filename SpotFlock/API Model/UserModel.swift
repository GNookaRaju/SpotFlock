//
//  UserModel.swift
//  SpotFlock
//
//  Created by Nuviso Infore on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import Foundation

// MARK: - User
class User: Codable {
    let id: Int
    let name, email: String
    let emailVerifiedAt: JSONNull?
    let apiToken, rateLimit: String
    let walletBalance, facebook, google, twitter: Int
    let userType: String
    let deletedAt: JSONNull?
    let createdAt, updatedAt: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name, email
        case emailVerifiedAt = "email_verified_at"
        case apiToken = "api_token"
        case rateLimit = "rate_limit"
        case walletBalance = "wallet_balance"
        case facebook, google, twitter
        case userType = "user_type"
        case deletedAt = "deleted_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
    
    init(id: Int, name: String, email: String, emailVerifiedAt: JSONNull?, apiToken: String, rateLimit: String, walletBalance: Int, facebook: Int, google: Int, twitter: Int, userType: String, deletedAt: JSONNull?, createdAt: String?, updatedAt: String?) {
        self.id = id
        self.name = name
        self.email = email
        self.emailVerifiedAt = emailVerifiedAt
        self.apiToken = apiToken
        self.rateLimit = rateLimit
        self.walletBalance = walletBalance
        self.facebook = facebook
        self.google = google
        self.twitter = twitter
        self.userType = userType
        self.deletedAt = deletedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
