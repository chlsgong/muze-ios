//
//  UserModel.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class UserModel {
    var id: String
    var phoneNumber: String
    var badgeCount: Int
    var apnToken: String
    var ownedPlaylists: [String]
    var sharedPlaylists: [String]
    
    init(id: String, phoneNumber: String, badgeCount: Int, apnToken: String, ownedPlaylists: [String], sharedPlaylists: [String]) {
        self.id = id
        self.phoneNumber = phoneNumber
        self.badgeCount = badgeCount
        self.apnToken = apnToken
        self.ownedPlaylists = ownedPlaylists
        self.sharedPlaylists = sharedPlaylists
    }
}
