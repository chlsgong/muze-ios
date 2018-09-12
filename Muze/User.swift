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
    
    private var _id: String
    private var _apnToken: String
    private var _phoneNumber: String
    private var _serviceProvider: ServiceProvider
    private var _isLoggedIn: Bool
    private var _spotifyRefreshToken: String
    private var _appleMusicDevToken: String // For now, persist all the time. TODO: retrieve from backend
    private var _appleMusicUserToken: String
    
    private init() {
        _id = ""
        _apnToken = ""
        _phoneNumber = ""
        _serviceProvider = .none
        _isLoggedIn = false
        _spotifyRefreshToken = ""
        _appleMusicDevToken = ""
        _appleMusicUserToken = ""
    }
    
    // MARK: Public getters and setters
    
    var id: String {
        get {
            return _id
        }
        set(id) {
            set(value: id, forKey: .userId)
            _id = id
        }
    }
    
    var apnToken: String {
        get {
            return _apnToken
        }
        set(apnToken) {
            set(value: apnToken, forKey: .apnToken)
            _apnToken = apnToken
        }
    }
    
    var phoneNumber: String {
        get {
            return _phoneNumber
        }
        set(phoneNumber) {
            set(value: phoneNumber, forKey: .phoneNumber)
            _phoneNumber = phoneNumber
        }
    }
    
    var serviceProvider: ServiceProvider {
        get {
            return _serviceProvider
        }
        set(serviceProvider) {
            set(value: serviceProvider, forKey: .serviceProvider)
            _serviceProvider = serviceProvider
        }
    }
    
    var isLoggedIn: Bool {
        get {
            return _isLoggedIn
        }
        set(isLoggedIn) {
            set(value: isLoggedIn, forKey: .isLoggedIn)
            _isLoggedIn = isLoggedIn
        }
    }
    
    var spotifyRefreshToken: String {
        get {
            return _spotifyRefreshToken
        }
        set(spotifyRefreshToken) {
            set(value: spotifyRefreshToken, forKey: .spotifyRefreshToken)
            _spotifyRefreshToken = spotifyRefreshToken
        }
    }
    
    var appleMusicDevToken: String {
        get {
            return _appleMusicDevToken
        }
        set(appleMusicDevToken) {
            set(value: appleMusicDevToken, forKey: .appleMusicDevToken)
            _appleMusicDevToken = appleMusicDevToken
        }
    }
    
    var appleMusicUserToken: String {
        get {
            return _appleMusicUserToken
        }
        set(appleMusicUserToken) {
            set(value: appleMusicUserToken, forKey: .appleMusicUserToken)
            _appleMusicUserToken = appleMusicUserToken
        }
    }
    
    // MARK: Instance methods
    
    // Must call this method on start up
    func retrieveLoginInfo() {
        _id = string(forKey: .userId)
        _apnToken = string(forKey: .apnToken)
        _phoneNumber = string(forKey: .phoneNumber)
        _serviceProvider = serviceProvider(forKey: .serviceProvider)
        _isLoggedIn = bool(forKey: .isLoggedIn)
        _spotifyRefreshToken = string(forKey: .spotifyRefreshToken)
        // _appleMusicDevToken = string(forKey: .appleMusicDevToken)
        _appleMusicUserToken = string(forKey: .appleMusicUserToken)
        
        _appleMusicDevToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkU5R01WQUQ1RFQifQ.eyJpc3MiOiJITVlDTkU1OVMyIiwiaWF0IjoxNTMwNDY5ODU1LCJleHAiOjE1MzgzNTgzNTV9.HiQa2wL3Wu0dLkpZ0DxUX-Ek1abO2Hu3aTWz3-_8zDmjecRhVKgb5DZwFWueNALzne9WeGkI6OjdbLx0n9KxVg"
    }
    
    func clearLoginInfo() {
        set(value: "", forKey: .userId)
        set(value: "", forKey: .apnToken)
        set(value: "", forKey: .phoneNumber)
        set(value: .none, forKey: .serviceProvider)
        set(value: false, forKey: .isLoggedIn)
        set(value: "", forKey: .spotifyRefreshToken)
        set(value: "", forKey: .appleMusicDevToken)
        set(value: "", forKey: .appleMusicUserToken)
        
        _id = ""
        _apnToken = ""
        _phoneNumber = ""
        _serviceProvider = .none
        _isLoggedIn = false
        _spotifyRefreshToken = ""
        // _appleMusicDevToken = ""
        _appleMusicUserToken = ""
    }
    
    // MARK: Private getters
    
    private func string(forKey key: UserDefaultsKey) -> String {
        return defaults.string(forKey: key.rawValue) ?? ""
    }
    
    private func bool(forKey key: UserDefaultsKey) -> Bool {
        return defaults.bool(forKey: key.rawValue)
    }
    
    private func serviceProvider(forKey key: UserDefaultsKey) -> ServiceProvider {
        return ServiceProvider(rawValue: defaults.string(forKey: key.rawValue) ?? ServiceProvider.none.rawValue)!
    }
    
    // MARK: Private setters
    
    private func set(value: String, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    private func set(value: Bool, forKey key: UserDefaultsKey) {
        defaults.set(value, forKey: key.rawValue)
    }
    
    private func set(value: ServiceProvider, forKey key: UserDefaultsKey) {
        defaults.set(value.rawValue, forKey: key.rawValue)
    }
}
