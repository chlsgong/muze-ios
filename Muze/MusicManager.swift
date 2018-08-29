//
//  MusicManager.swift
//  Muze
//
//  Created by Charles Gong on 8/11/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicManager {
    static let standard = MusicManager()
    
    let musicClient = MusicClient()
    
    var serviceProvider: ServiceProvider
    
    private init() {
        // Save service provider in user defaults and retrieve
        serviceProvider = User.standard.serviceProvider
    }
    
    // only consider Apple Music for now
    func queryAllPlaylists() -> [MPMediaItemCollection] {
        var playlists = [MPMediaItemCollection]()
        
        switch(serviceProvider) {
        case .appleMusic:
            print("apple music")
            playlists = queryAllPlaylistsFromAppleMusic()
        case .spotify:
            print("spotify")
        default:
            print("none")
        }
        
        return playlists
    }
    
    func savePlaylist(playlist: PlaylistModel) {
        let title = playlist.title
        let songs = playlist.playlist
        
        // TODO: change this to decorator pattern
        if serviceProvider == .appleMusic {
            let playlistUUID = UUID() // use playlist id?
            
            let playlistCreationMetadata = MPMediaPlaylistCreationMetadata(name: title)
            
            MPMediaLibrary.default().getPlaylist(with: playlistUUID, creationMetadata: playlistCreationMetadata) { playlist, error in
                if error != nil {
                    print(error!)
                }
            }
        }
        else if serviceProvider == .spotify {
            musicClient.createPlaylist(title: title) { playlistId, error in
                if error != nil {
                    print(error!)
                }
                else {
                    for track in songs {
                        self.musicClient.querySong(title: track["title"]!, artist: track["artist"]!) { trackId, name, error in
                            self.musicClient.addTracksToPlaylist(playlistId: playlistId!, trackIds: [trackId!]) { error in
                                if error != nil {
                                    print(error)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Helpers
    
    //        let playlistQuery = MPMediaQuery.playlists()
    //        let playlistCollections = playlistQuery.collections!
    //        for playlist in playlistCollections {
    //            print(playlist.value(forProperty: MPMediaPlaylistPropertyName))
    //                for item in playlist.items {
    //                    print("\(item.title) \(item.artist)")
    //            }
    //        }
    
    private func queryAllPlaylistsFromAppleMusic() -> [MPMediaItemCollection] {
        let playlistQuery = MPMediaQuery.playlists()
        let playlistCollections = playlistQuery.collections!
        
        return playlistCollections
    }
}

typealias Song = [String: String]

extension MPMediaItemCollection {
    func playlistName() -> String {
        return (self.value(forProperty: MPMediaPlaylistPropertyName) as? String) ?? "Untitled playlist"
    }
    
    func playlistJSON() -> [Song] {
        var playlistJSON = [Song]()
        for playlist in self.items {
            playlistJSON.append(["title": playlist.title!, "artist": playlist.artist!])
        }
        
        return playlistJSON
    }
}
