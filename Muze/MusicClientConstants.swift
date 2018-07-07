//
//  MusicClientConstants.swift
//  Muze
//
//  Created by Charles Gong on 7/1/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

// Music service providers
enum ServiceProvider: String {
    case appleMusic
    case spotify
    case none
}

// Spotify constants
let spotifyClientId = "0c57961c512a4ab1bde7c3d6fcc045e7"
let redirectUri = "muze://"

// Music service API endpoints
enum ServiceEndpoint {
    // Spotify endpoints
    case getAuthorizeSpotify
    
    var url: String {
        switch self {
        case .getAuthorizeSpotify: return spotifyDomainAccounts + "/authorize"
        }
    }
}
