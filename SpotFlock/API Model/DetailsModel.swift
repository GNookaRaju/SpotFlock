//
//  DetailsModel.swift
//  SpotFlock
//
//  Created by SpotFlock on 31/07/19.
//  Copyright © 2019 Spotflock. All rights reserved.
//

import Foundation

// MARK: - LoginDetails
class ResponseDetails: Codable {
    let status, message: String?
    let user: User?
    let errors: Errors?
    let success: Bool?
    
    init(status: String?, message: String?, user: User?, error: Errors?, success: Bool?) {
        self.status = status
        self.message = message
        self.user = user
        self.errors = error
        self.success = success
    }
}

// MARK: - Errors
class Errors: Codable {
    let name, email, mobile, gender: [String]?
    let password: [String]?
    
    init(name: [String]?, email: [String]?, mobile: [String]?, gender: [String]?, password: [String]?) {
        self.name = name
        self.email = email
        self.mobile = mobile
        self.gender = gender
        self.password = password
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {
    
    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
