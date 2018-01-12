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
    
    var serviceProvider: ServiceProvider
    
    private init() {
        // Save service provider in user defaults and retrieve
        serviceProvider = .none
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

enum ServiceProvider: String {
    case appleMusic
    case spotify
    case none
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
