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
    private let manager: SocketManager
    private let socket: SocketIOClient
    
    init() {
        manager = SocketManager(socketURL: URL(string: ipAddress)!, config: [.log(false), .compress])
        socket = manager.socket(forNamespace: "/playlists")
    }
    
    func connect() {
        socket.joinNamespace()
        socket.connect()
    }
    
    func disconnect() {
        socket.disconnect()
    }
    
    func onError(callback: @escaping () -> Void) {
        socket.on(clientEvent: .error) { data, _ in
            print(data)
            callback()
        }
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
