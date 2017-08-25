//
//  PlaylistAddPlaylistViewController.swift
//  Muze
//
//  Created by Charles Gong on 8/17/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit
import MediaPlayer

class PlaylistAddPlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var playlistTableView: UITableView!
    
    private let musicMgr = MusicManager.standard
    private let muzeClient = MuzeClient()
    
    var playlistId: String!
    var size: Int!
    var playlists = [MPMediaItemCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView.delegate = self
        
        playlists = musicMgr.queryAllPlaylists()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if let container = parent as? PlaylistAddMusicViewController {
            playlistId = container.playlistId
            size = container.size
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistAddPlaylistCell, for: indexPath) as! PlaylistAddPlaylistTableViewCell
        
        let playlist = playlists[indexPath.row]
        cell.playlistTitle.text = playlist.playlistName()
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlaylistAddPlaylistTableViewCell
        cell.isUserInteractionEnabled = false
        
        let playlist = playlists[indexPath.row].playlistJSON()
        
        size = size + playlist.count
        
        muzeClient.updatePlaylistSongs(playlistId: playlistId, playlist: playlist, size: size) { error in
            if error == nil {
                cell.addPlaylistLabel.text = ""
            }
            cell.isUserInteractionEnabled = true
            cell.setSelected(false, animated: true)
        }
    }

}
