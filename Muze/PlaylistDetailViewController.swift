//
//  PlaylistDetailViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit
import SocketIO

// - TODO:
// Leave playlist function

class PlaylistDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, RemovableCellDelegate {
    @IBOutlet weak var playlistDetailTableView: UITableView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    private let muzeClient = MuzeClient()
    private let socketClient = SocketClient()
    
    var playlistModel: PlaylistModel!
    var playlist = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistDetailTableView.delegate = self
        playlistDetailTableView.dataSource = self
        
        self.navigationItem.title = playlistModel.title
        
        registerSocketEvents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        socketClient.connect()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        socketClient.disconnect()
        super.viewDidDisappear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isIdentified(byId: .toAddListeners) {
            if let destination = segue.destination as? PlaylistListenersViewController {
                destination.playlistId = playlistModel.id
            }
        }
        else if segue.isIdentified(byId: .toAddMusic) {
            if let destination = segue.destination as? PlaylistAddMusicViewController {
                destination.playlistId = playlistModel.id
                destination.size = playlistModel.size
            }
        }
    }
    
    private func reloadTableView(playlistModel: PlaylistModel) {
        self.playlistModel = playlistModel
        self.playlist = playlistModel.playlist
        
        self.playlistDetailTableView.reloadData()
    }
    
    private func registerSocketEvents() {
        socketClient.onConnect {
            self.muzeClient.getPlaylist(playlistModel: self.playlistModel) { playlistModel in
                self.reloadTableView(playlistModel: playlistModel)
            }
            self.socketClient.emitRoom(roomId: self.playlistModel.id)
        }
        
        socketClient.onUpdatePlaylist(playlistModel: playlistModel) { playlistModel in
            self.playlistModel = playlistModel
            self.reloadTableView(playlistModel: playlistModel)
        }
        
        socketClient.onUpdatePlaylistTitle { title in
            self.playlistModel.update(title: title)
            self.navigationItem.title = title
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistDetailCell, for: indexPath) as! PlaylistDetailTableViewCell
        
        cell.selectionStyle = .none
        cell.songTitleLabel.text = playlist[indexPath.row]["title"]
        cell.songArtistLabel.text = playlist[indexPath.row]["artist"]
        cell.delegate = self
        
        return cell
    }
    
    // MARK: RemovableCellDelegate methods
    
    func removeButtonTapped(_ cell: UITableViewCell) {
        let detailTableViewCell = cell as! PlaylistDetailTableViewCell
        
        detailTableViewCell.removeButton.isEnabled = false
        if let cellIndex = playlistDetailTableView.indexPath(for: detailTableViewCell)?.row {
            var mutablePlaylist = playlist
            
            mutablePlaylist.remove(at: cellIndex)
            
            muzeClient.updatePlaylistSongs(playlistId: playlistModel.id, playlist: mutablePlaylist, size: mutablePlaylist.count) { error in
                detailTableViewCell.removeButton.isEnabled = true
            }
        }
    }
    
    // MARK: IBAction methods
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        
    }

}
