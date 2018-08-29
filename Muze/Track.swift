//
//  Track.swift
//  Muze
//
//  Created by Charles Gong on 8/26/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

class Track {
    private(set) var appleMusicId: String
    private(set) var spotifyId: String
    private(set) var title: String
    private(set) var artist: String
    private(set) var isEnabled: Bool
    
    init(appleMusicId: String = "", spotifyId: String = "", title: String, artist: String, isEnabled: Bool) {
        self.appleMusicId = appleMusicId
        self.spotifyId = spotifyId
        self.title = title
        self.artist = artist
        self.isEnabled = isEnabled
    }
}
