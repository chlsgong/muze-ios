//
//  SpotifyClient.swift
//  Muze
//
//  Created by Charles Gong on 9/13/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

class SpotifyClient: MusicServiceClient {
    static let shared = SpotifyClient()
    
    private init() {}
    
    func getPlaylists(completion: @escaping ([PlaylistModel]?, Error?) -> Void) {
    }
    
    func getPlaylistTracks(playlist: PlaylistModel, completion: @escaping (PlaylistModel, Error?) -> Void) {
    }

    func createPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
    }
    
    func addTracksToPlaylist(playlist: PlaylistModel, completion: @escaping (Error?) -> Void) {
    }
    
    func queryTrack() {
    }
}
