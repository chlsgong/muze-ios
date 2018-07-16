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

enum SpotifyScope: String {
    // Users
    case userReadPrivate = "user-read-private"
    case userReadBirthdate = "user-read-birthdate"
    case userReadEmail = "user-read-email"
    
    // Playlist
    case playlistModifyPrivate = "playlist-modify-private"
    case playlistReadPrivate = "playlist-read-private"
    case playlistReadCollaborative = "playlist-read-collaborative"
    case playlistModifyPublic = "playlist-modify-public"
    
    // Follow
    case userFollowModify = "user-follow-modify"
    case userFollowRead = "user-follow-read"
    
    // Playback
    case appRemoteControl = "app-remote-control"
    case streaming = "streaming"
    
    // Spotify Connect
    case userReadCurrentlyPlaying = "user-read-currently-playing"
    case userModifyPlaybackState = "user-modify-playback-state"
    case userReadPlaybackState = "user-read-playback-state"
    
    // Library
    case userLibraryModify = "user-library-modify"
    case userLibraryRead = "user-library-read"
    
    // Listening History
    case userReadRecentlyPlayed = "user-read-recently-played"
    case userTopRead = "user-top-read"
}

// Spotify constants
struct SpotifyAuth {
    private static let _scopes: [SpotifyScope] = [
        .playlistModifyPrivate,
        .playlistReadPrivate,
        .playlistReadCollaborative,
        .playlistModifyPublic,
        .userLibraryModify,
        .userLibraryRead
    ]
    
    static let clientId = "0c57961c512a4ab1bde7c3d6fcc045e7"
    static let redirectUri = "muze://"
    static let responseType = "code"
    static var scopes: String { return _scopes.stringify() }
    
    static var code: String?
}
