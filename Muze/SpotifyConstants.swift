//
//  SpotifyConstants.swift
//  Muze
//
//  Created by Charles Gong on 10/12/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

let spotifyDomainAccounts = "https://accounts.spotify.com"
let spotifyDomainAPI = "https://api.spotify.com/v1"

// Spotify endpoints
enum SpotifyEndpoint {
    case getAuthorizeSpotify
    case postToken
    case getCurrentUser
    case getPlaylists
    case getPlaylistTracks(String)
    case postCreatePlaylist(String)
    case postAddTracksToPlaylist(String)
    case getSearch
    
    var url: String {
        switch self {
        case .getAuthorizeSpotify: return spotifyDomainAccounts + "/authorize"
        case .postToken: return spotifyDomainAccounts + "/api/token"
        case .getCurrentUser: return spotifyDomainAPI + "/me"
        case .getPlaylists: return spotifyDomainAPI + "/me/playlists"
        case .getPlaylistTracks(let playlistId): return spotifyDomainAPI + "/playlists/\(playlistId)/tracks"
        case .postCreatePlaylist(let userId): return spotifyDomainAPI + "/users/\(userId)/playlists"
        case .postAddTracksToPlaylist(let playlistId): return spotifyDomainAPI + "/playlists/\(playlistId)/tracks"
        case .getSearch: return spotifyDomainAPI + "/search"
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
