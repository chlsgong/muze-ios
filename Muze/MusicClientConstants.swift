//
//  MusicClientConstants.swift
//  Muze
//
//  Created by Charles Gong on 7/1/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

let spotifyDomainAccounts = "https://accounts.spotify.com"
let spotifyDomainAPI = "https://api.spotify.com/v1"

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
    case postToken
    case getCurrentUser
    case postCreatePlaylist
    case getSearch
    case postAddTracksToPlaylist(String)
    
    var url: String {
        switch self {
        case .getAuthorizeSpotify: return spotifyDomainAccounts + "/authorize"
        case .postToken: return spotifyDomainAccounts + "/api/token"
        case .getCurrentUser: return spotifyDomainAPI + "/me"
        case .postCreatePlaylist: return spotifyDomainAPI + "/users/\(SpotifyAuth.userId!)/playlists" // TODO: change to the same as below
        case .getSearch: return spotifyDomainAPI + "/search"
        case .postAddTracksToPlaylist(let playlistId): return spotifyDomainAPI + "/playlists/\(playlistId)/tracks"
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
        .playlistModifyPublic,
        .playlistReadPrivate,
        .playlistReadCollaborative,
        .userLibraryModify,
        .userLibraryRead
    ]
    
    static let clientId = "0c57961c512a4ab1bde7c3d6fcc045e7"
    static let clientSecret = "9763ecb79f7b4e8f8cef5850ccd2172f"
    static let redirectUri = "muze://"
    static let responseType = "code"
    static let grantType = "authorization_code"
    static var scopes: String { return _scopes.stringify() }
    
    static var code: String?
    static var accessToken: String?
    static var userId: String?
    static var expirationDate: Date?
}
