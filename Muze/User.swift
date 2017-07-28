//
//  User.swift
//  Muze
//
//  Created by Charles Gong on 7/28/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class User {
    static let standard = User()
    
    private let defaults = UserDefaults.standard
    
    private(set) var userId: String
    private(set) var apnToken: String
    private(set) var phoneNumber: String
    
    private init() {
        userId = ""
        apnToken = ""
        phoneNumber = ""
    }
    
    // Must call this method on initialization
    func retrieveLoginInfo() {
        userId = string(forKey: .userId)
        apnToken = string(forKey: .apnToken)
        phoneNumber = string(forKey: .phoneNumber)
    }
    
    func updateLoginInfo(userId: String, apnToken: String, phoneNumber: String) {
        set(value: userId, forKey: .userId)
        set(value: apnToken, forKey: .apnToken)
        set(value: phoneNumber, forKey: .phoneNumber)
        
        self.userId = userId
        self.apnToken = apnToken
        self.phoneNumber = phoneNumber
    }
    
    private func string(forKey key: UserDefaultsKey) -> String {
        return defaults.string(forKey: key.rawValue) ?? ""
    }
    
    private func set(value: String, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
}
