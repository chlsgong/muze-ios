//
//  AppleMusicConstants.swift
//  Muze
//
//  Created by Charles Gong on 9/6/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

let appleMusicLibrary = "https://api.music.apple.com/v1/me/library"
let appleMusicCatalog = "https://api.music.apple.com/v1/catalog"

enum AppleMusicEndpoint {
    case getLibraryPlaylists
    case getLibraryPlaylistTracks(String)
    case postCreateLibraryPlaylist
    case postAddLibraryPlaylistTracks(String)
    case getSearchCatalog
    
    var url: String {
        switch self {
        case .getLibraryPlaylists: return "\(appleMusicLibrary)/playlists"
        case .getLibraryPlaylistTracks(let playlistId): return "\(appleMusicLibrary)/playlists/\(playlistId)/tracks"
        case .postCreateLibraryPlaylist: return "\(appleMusicLibrary)/playlists"
        case .postAddLibraryPlaylistTracks(let playlistId): return "\(appleMusicLibrary)/playlists/\(playlistId)/tracks"
        case .getSearchCatalog: return "\(appleMusicCatalog)/us/search" // NOTE: default to 'us' storefront for now
        }
    }
}

typealias AppleMusicTrackRequestData = [String: String]
