//
//  MusicManager.swift
//  Muze
//
//  Created by Charles Gong on 8/11/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class MusicManager {
    static let standard = MusicManager()
    
    var serviceProvider: ServiceProvider
    
    private init() {
        serviceProvider = .none
    }
    
    
//    let playlistQuery = MPMediaQuery.playlists()
//    let playlistCollections = playlistQuery.collections!
//    for playlist in playlistCollections {
//    print(playlist.value(forProperty: MPMediaPlaylistPropertyName))
//    for item in playlist.items {
//    print("\(item.title) \(item.artist)")
//    }
//    }
    
    
    
}

enum ServiceProvider {
    case appleMusic
    case spotify
    case none
}
