//
//  Track.swift
//  Muze
//
//  Created by Charles Gong on 8/26/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

class Track {
    private(set) var id: String
    private(set) var appleMusicId: String
    private(set) var spotifyId: String
    private(set) var title: String
    private(set) var artist: String
    private(set) var isExplicit: Bool
    
    init(id: String = "", appleMusicId: String = "", spotifyId: String = "", title: String, artist: String, isExplicit: Bool) {
        self.id = id
        self.appleMusicId = appleMusicId
        self.spotifyId = spotifyId
        self.title = title
        self.artist = artist
        self.isExplicit = isExplicit
    }
    
    func muzeRequestData() -> MuzeTrackRequestData {
        return [
            "appleMusicId": self.appleMusicId,
            "spotifyId": self.spotifyId,
            "title": self.title,
            "artist": self.artist,
            "isExplicit": String(self.isExplicit)
        ]
    }
    
    func appleMusicRequestData() -> AppleMusicTrackRequestData {
        return [
            "id": self.appleMusicId,
            "type": "songs"
        ]
    }
}

enum ContentRating: String {
    case clean
    case explicit
}
