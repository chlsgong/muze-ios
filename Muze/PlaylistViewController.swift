//
//  PlaylistViewController.swift
//  Muze
//
//  Created by Charles Gong on 6/26/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit
import MediaPlayer
import UserNotifications

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var playlistTableView: UITableView!
    
    private let authMgr = AuthorizationManager()
    private let muzeClient = MuzeClient()
    private let user = User.standard
    
    var playlist = [PlaylistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
//        let playlistQuery = MPMediaQuery.playlists()
//        let playlistCollections = playlistQuery.collections!
//        for playlist in playlistCollections {
//            print(playlist.value(forProperty: MPMediaPlaylistPropertyName))
//            for item in playlist.items {
//                print(item.title)
//            }
//        }
        
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        
        authMgr.requestNotificationCenterAuthorization { _ in }
        authMgr.registerForRemoteNotificationsIfNeeded()
        
        print(user.userId)
        print(user.phoneNumber)
        print(user.apnToken)
        
        muzeClient.getUser(userId: user.userId) { userModel in
            guard userModel != nil else { return }
            
            let userPlaylists = userModel!.sharedPlaylists + userModel!.ownedPlaylists
            
            self.muzeClient.getPlaylistTitles(playlistIds: userPlaylists) { playlistModels in
                self.playlist = playlistModels
                self.playlistTableView.reloadData()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isIdentified(byId: .toPlaylistDetail) {
            if let destination = segue.destination as? PlaylistDetailViewController {
                destination.playlistModel = sender as! PlaylistModel
            }
        }
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlist, for: indexPath)
        cell.textLabel?.text = playlist[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: .toPlaylistDetail, sender: playlist[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

