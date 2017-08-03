//
//  PlaylistModel.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

class PlaylistModel {
    var id: String
    var title: String
    var creationTime: Date
    var creatorId: String
    var playlist: [Song]
    var size: Int
    
    init(id: String, title: String, creationTime: Date) {
        self.id = id
        self.title = title
        self.creationTime = creationTime
        self.creatorId = ""
        self.playlist = []
        self.size = 0
    }
    
    convenience init(id: String, title: String, creationTime: String) {
        // convert creationTime to date
        self.init(id: id, title: title, creationTime: Date())
    }
    
    func update(id: String, title: String, creationTime: String, creatorId: String, playlist: [Song], size: Int) {
        self.id = id
        self.title = title
        self.creationTime = Date()
        self.creatorId = creatorId
        self.playlist = playlist
        self.size = size
    }
}
