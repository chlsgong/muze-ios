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
    private(set) var title: String
    private(set) var creationTime: Date
    private(set) var creatorId: String
    private(set) var playlist: [Song] // TODO: rename to songs
    private(set) var size: Int
    
    init(id: String, title: String, creationTime: Date) {
        self.id = id
        self.title = title
        self.creationTime = creationTime
        self.creatorId = ""
        self.playlist = []
        self.size = 0
    }
    
    convenience init(id: String, title: String, creationTime: String) {
        self.init(id: id, title: title, creationTime: Date())
    }
    
    func update(title: String, creationTime: String, creatorId: String, playlist: [Song], size: Int) {
        self.title = title
        self.creationTime = Date()
        self.creatorId = creatorId
        self.playlist = playlist
        self.size = size
    }
    
    func update(playlist: [Song], size: Int) {
        self.playlist = playlist
        self.size = size
    }
    
    func update(title: String) {
        self.title = title
    }
    
}
