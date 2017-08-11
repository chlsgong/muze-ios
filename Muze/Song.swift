//
//  Song.swift
//  Muze
//
//  Created by Charles Gong on 8/2/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class Song {
    private(set) var title: String
    private(set) var artist: String
    
    init(title: String, artist: String) {
        self.title = title
        self.artist = artist
    }
}
