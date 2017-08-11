//
//  UserModel.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class UserModel {
    private(set) var id: String
    private(set) var phoneNumber: String
    private(set) var badgeCount: Int
    private(set) var apnToken: String
    private(set) var ownedPlaylists: [String]
    private(set) var sharedPlaylists: [String]
    
    init(id: String, phoneNumber: String, badgeCount: Int, apnToken: String, ownedPlaylists: [String], sharedPlaylists: [String]) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.badgeCount = badgeCount
        self.apnToken = apnToken
        self.ownedPlaylists = ownedPlaylists
        self.sharedPlaylists = sharedPlaylists
    }
}
