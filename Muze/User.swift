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
    private(set) var isLoggedIn: Bool
    
    private init() {
        userId = ""
        apnToken = ""
        phoneNumber = ""
        isLoggedIn = false
    }
    
    // Must call this method on initialization
    func retrieveLoginInfo() {
        userId = string(forKey: .userId)
        apnToken = string(forKey: .apnToken)
        phoneNumber = string(forKey: .phoneNumber)
        isLoggedIn = bool(forKey: .isLoggedIn)
    }
    
    func updateLoginInfo(userId: String, apnToken: String, phoneNumber: String, isLoggedIn: Bool) {
        set(value: userId, forKey: .userId)
        set(value: apnToken, forKey: .apnToken)
        set(value: phoneNumber, forKey: .phoneNumber)
        set(value: isLoggedIn, forKey: .isLoggedIn)
        
        self.userId = userId
        self.apnToken = apnToken
        self.phoneNumber = phoneNumber
        self.isLoggedIn = isLoggedIn
    }
    
    private func string(forKey key: UserDefaultsKey) -> String {
        return defaults.string(forKey: key.rawValue) ?? ""
    }
    
    private func bool(forKey key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    
    private func set(value: String, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    private func set(value: Bool, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
}
