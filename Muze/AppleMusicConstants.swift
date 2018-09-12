//
//  AppleMusicConstants.swift
//  Muze
//
//  Created by Charles Gong on 9/6/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

let appleMusicLibrary = "https://api.music.apple.com/v1/me/library"

enum AppleMusicEndpoint {
    case getLibraryPlaylists
    
    var url: String {
        switch self {
        case .getLibraryPlaylists: return "\(appleMusicLibrary)/playlists"
        }
    }
}
