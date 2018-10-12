//
//  PlaylistModel.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

// - TODO:
// Convert creationTime to Date

class PlaylistModel {    
    private(set) var id: String
    private(set) var appleMusicId: String
    private(set) var spotifyId: String
    private(set) var title: String
    private(set) var creationTime: Date
    private(set) var creatorId: String
    private(set) var playlist: [Song] // TODO: rename to songs
    private(set) var tracks: [Track]
    private(set) var size: Int
    
    init(id: String, appleMusicId: String, spotifyId: String, title: String, creationTime: Date = Date()) {
        self.id = id
        self.appleMusicId = appleMusicId
        self.spotifyId = spotifyId
        self.title = title
        self.creationTime = creationTime
        self.creatorId = ""
        self.playlist = []
        self.tracks = []
        self.size = 0
    }
    
    convenience init(id: String, title: String, creationTime: String) {
        self.init(id: id, appleMusicId: "", spotifyId: "", title: title, creationTime: Date())
    }
    
    convenience init(appleMusicId: String, title: String) {
        self.init(id: "", appleMusicId: appleMusicId, spotifyId: "", title: title)
    }
    
    convenience init(spotifyId: String, title: String) {
        self.init(id: "", appleMusicId: "", spotifyId: spotifyId, title: title)
    }
    
    // TODO: change to one generic update
    func update(title: String, creationTime: String, creatorId: String, playlist: [Song], size: Int) {
        self.title = title
        self.creationTime = Date()
        self.creatorId = creatorId
        self.playlist = playlist
        self.size = size
    }
    
    func update(title: String, creationTime: String, creatorId: String, tracks: [Track], size: Int) {
        self.title = title
        self.creationTime = Date()
        self.creatorId = creatorId
        self.tracks = tracks
        self.size = size
    }
    
    func update(playlist: [Song], size: Int) {
        self.playlist = playlist
        self.size = size
    }
    
    func update(tracks: [Track], size: Int) {
        self.tracks = tracks
        self.size = size
    }
    
    func update(title: String) {
        self.title = title
    }
    
    func muzeRequestData() -> [MuzeTrackRequestData] {
        var tracksData = [MuzeTrackRequestData]()
        for track in tracks {
            tracksData.append(track.muzeRequestData())
        }
        
        return tracksData
    }
    
    func appleMusicTracksRequestData() -> [String: Any] {
        var tracksData = [AppleMusicTrackRequestData]()
        for track in tracks {
            tracksData.append(track.appleMusicRequestData())
        }
        
        return ["data": tracksData]
    }
}
