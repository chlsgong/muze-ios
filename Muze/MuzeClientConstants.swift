//
//  MuzeClientConstants.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

// API endpoints
enum Endpoint {
    case postVerificationCode
    case getVerificationCheck
    case putUsersAPNToken
    case getUsers
    case postPlaylist
    case getPlaylistTitle
    case getPlaylist
    case putPlaylistSongs
    case getPlaylistUsers
    case putPlaylistUsers
    case deletePlaylistUsers
    
    var url: String {
        let host = ipAddress
        
        switch self {
        case .postVerificationCode: return host + "/verification/code"
        case .getVerificationCheck: return host + "/verification/check"
        case .putUsersAPNToken: return host + "/users/apntoken"
        case .getUsers: return host + "/users"
        case .postPlaylist: return host + "/playlist"
        case .getPlaylistTitle: return host + "/playlist/title"
        case .getPlaylist: return host + "/playlist"
        case .putPlaylistSongs: return host + "/playlist/songs"
        case .getPlaylistUsers: return host + "/playlist/users"
        case .putPlaylistUsers: return host + "/playlist/users"
        case .deletePlaylistUsers: return host + "/playlist/users"
        }
    }
}

typealias MuzeTrackRequestData = [String: String]
