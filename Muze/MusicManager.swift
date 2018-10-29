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
    static let shared = MusicManager()
    
    private init() {}
    
    // MARK: Properties
    
    private let musicServiceClients: [MusicServiceProvider: MusicServiceClient] = [
        .spotify: SpotifyClient.shared,
        .appleMusic: AppleMusicClient.shared
    ]
    
    private var musicServiceClient: MusicServiceClient? {
        return musicServiceClients[User.standard.serviceProvider]
    }
    
    // MARK: Music service client methods
    
    func getPlaylists(completion: @escaping ([PlaylistModel]) -> Void) {
        musicServiceClient?.getPlaylists { playlists, error in
            self.handleError(error: error) {
                completion(playlists!)
            }
        }
    }
    
    func getPlaylistTracks(playlist: PlaylistModel, completion: @escaping (PlaylistModel) -> Void) {
        musicServiceClient?.getPlaylistTracks(playlist: playlist) { playlist, error in
            self.handleError(error: error) {
                completion(playlist)
            }
        }
    }
    
    func createPlaylist(playlist: PlaylistModel, completion: @escaping () -> Void) {
        musicServiceClient?.createPlaylist(playlist: playlist) { error in
            self.handleError(error: error) {
                completion()
            }
        }
    }
    
    func addTracksToPlaylist(playlist: PlaylistModel, completion: @escaping () -> Void) {
        musicServiceClient?.addTracksToPlaylist(playlist: playlist) { error in
            self.handleError(error: error) {
                completion()
            }
        }
    }
    
    func queryTrack() {
        musicServiceClient?.queryTrack()
    }
    
    // MARK: Helpers
    
    private func handleError(error: Error?, completion: @escaping () -> Void) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        completion()
    }
    
    // Only consider Apple Music for now
//    func queryAllPlaylists(completion: @escaping ([PlaylistModel]) -> Void) {
//        switch(serviceProvider) {
//        case .appleMusic:
//            print("apple music")
//            AppleMusicClient.shared.getPlaylists { playlists, error in
//                if error == nil {
//                    completion(playlists!)
//                }
//            }
//        case .spotify:
//            print("spotify")
//        default:
//            print("none")
//        }
//    }
    
//    func savePlaylist(playlist: PlaylistModel) {
//        let title = playlist.title
//        let songs = playlist.playlist
//
//        // TODO: change this to decorator pattern
//        if serviceProvider == .appleMusic {
//            let playlistUUID = UUID() // use playlist id?
//
//            let playlistCreationMetadata = MPMediaPlaylistCreationMetadata(name: title)
//
//            MPMediaLibrary.default().getPlaylist(with: playlistUUID, creationMetadata: playlistCreationMetadata) { playlist, error in
//                if error != nil {
//                    print(error!)
//                }
//            }
//        }
//        else if serviceProvider == .spotify {
//            musicClient.createPlaylist(title: title) { playlistId, error in
//                if error != nil {
//                    print(error!)
//                }
//                else {
//                    for track in songs {
//                        self.musicClient.querySong(title: track["title"]!, artist: track["artist"]!) { trackId, name, error in
//                            self.musicClient.addTracksToPlaylist(playlistId: playlistId!, trackIds: [trackId!]) { error in
//                                if error != nil {
//                                    print(error!)
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//        }
//    }
    
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
        for track in self.items {
            print("persistent ID", track.persistentID)
            playlistJSON.append(["title": track.title!, "artist": track.artist!])
        }
        
        return playlistJSON
    }
}
