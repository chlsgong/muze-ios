//
//  SocketClientConstants.swift
//  Muze
//
//  Created by Charles Gong on 8/10/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

enum Event: String {
    case connect = "connect"
    case room = "room"
    case updatePlaylist = "updatePlaylist"
    case updatePlaylistTitle = "updatePlaylistTitle"
}
