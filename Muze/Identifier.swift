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
        case backToLogin = "BackToLogin"
        case toConnect = "ToConnect"
        case toConfirm = "ToConfirm"
        case toPlaylistDetail = "ToPlaylistDetail"
        case toAddListeners = "ToAddListeners"
        case toContacts = "ToContacts"
        case toAddMusic = "ToAddMusic"
    }
    
    enum Cell: String {
        case playlist = "PlaylistCell"
        case playlistDetailCell = "PlaylistDetailCell"
        case playlistListenersCell = "PlaylistListenersCell"
        case playlistContactsCell = "PlaylistContactsCell"
        case playlistAddPlaylistCell = "PlaylistAddPlaylistCell"
    }
    
    enum ViewController: String {
        case login = "Login"
        case playlistAddPlaylist = "PlaylistAddPlaylist"
        case playlistSearchMusic = "PlaylistSearchMusic"
    }
    
    enum TabBarController: String {
        case mainTabBar = "MainTabBar"
    }
}
