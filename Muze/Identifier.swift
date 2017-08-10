//
//  Identifier.swift
//  Muze
//
//  Created by Charles Gong on 6/18/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation

enum Identifier {
    enum Segue: String {
        case toConnect = "ToConnect"
        case toConfirm = "ToConfirm"
        case toTabBar = "ToTabBar"
        case toPlaylistDetail = "ToPlaylistDetail"
        case toAddListeners = "ToAddListeners"
        case toContacts = "ToContacts"
    }
    
    enum Cell: String {
        case playlist = "PlaylistCell"
        case playlistDetailCell = "PlaylistDetailCell"
        case playlistListenersCell = "PlaylistListenersCell"
        case playlistContactsCell = "PlaylistContactsCell"
    }
}
