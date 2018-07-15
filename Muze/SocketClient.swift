//
//  SocketClient.swift
//  Muze
//
//  Created by Charles Gong on 8/10/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import SocketIO
import SwiftyJSON

// TODO: Make sure handlers on serial queues
class SocketClient {
    let socket = SocketManager(socketURL: URL(string: ipAddress)!, config: [.compress]).socket(forNamespace: "/playlists")
    
    func connect() {
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func onConnect(callback: @escaping () -> Void) {
        socket.on(clientEvent: .connect) { data, _ in
            callback()
        }
    }
    
    func onUpdatePlaylist(playlistModel: PlaylistModel, callback: @escaping (PlaylistModel) -> Void) {
        on(event: .updatePlaylist) { data, _ in
            let playlistData = JSON(data[0]).dictionaryValue
            let playlist = playlistData["playlist"]!.arrayObject as! [Song]
            let size = playlistData["size"]!.intValue
            playlistModel.update(playlist: playlist, size: size)
            
            callback(playlistModel)
        }
    }
    
    func onUpdatePlaylistTitle(callback: @escaping (String) -> Void) {
        on(event: .updatePlaylistTitle) { data, _ in
            let playlistData = JSON(data[0]).dictionaryValue
            let title = playlistData["title"]!.stringValue
            
            callback(title)
        }
    }
    
    func emitRoom(roomId: String) {
        emit(event: .room, items: roomId)
    }
    
    // MARK: Wrappers
    
    private func on(event: Event, callback: @escaping NormalCallback) {
        socket.on(event.rawValue, callback: callback)
    }
    
    private func emit(event: Event, items: SocketData...) {
        socket.emit(event.rawValue, items)
    }
    
}
