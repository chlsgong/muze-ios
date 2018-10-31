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
    
    private let musicMgr = MusicManager.shared
    private let muzeClient = MuzeClient()
    
    var muzePlaylist: PlaylistModel!
    var playlists = [PlaylistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        
        musicMgr.getPlaylists { playlists in
            self.playlists = playlists
            self.playlistTableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        if let container = parent as? PlaylistAddMusicViewController {
            muzePlaylist = container.muzePlaylist
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistAddPlaylistCell, for: indexPath) as! PlaylistAddPlaylistTableViewCell
        
        let playlistTitle = playlists[indexPath.row].title
        cell.playlistTitle.text = playlistTitle
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlaylistAddPlaylistTableViewCell
        cell.isUserInteractionEnabled = false
        
        let playlist = playlists[indexPath.row]
        musicMgr.getPlaylistTracks(playlist: playlist) { playlist in
            let tracks = self.muzePlaylist.tracks + playlist.tracks
            let size = self.muzePlaylist.size + playlist.size
            self.muzePlaylist.update(tracks: tracks, size: size)
            
            self.muzeClient.updatePlaylistSongs(playlistId: self.muzePlaylist.id, playlist: self.muzePlaylist.muzeRequestData(), size: size) { error in
                if error == nil {
                    cell.addPlaylistLabel.text = ""
                }
                cell.isUserInteractionEnabled = true
                cell.setSelected(false, animated: true)
            }
        }
    }

}
