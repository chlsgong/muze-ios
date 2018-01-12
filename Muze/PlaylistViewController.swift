//
//  PlaylistViewController.swift
//  Muze
//
//  Created by Charles Gong on 6/26/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit
import UserNotifications

// - TODO:
// Limit playlist name length
// Sort by newest creation date

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var playlistTableView: UITableView!
    @IBOutlet weak var createPlaylistButton: UIBarButtonItem!
    
    private var alert: UIAlertController?
    
    private let authMgr = AuthorizationManager()
    private let muzeClient = MuzeClient()
    private let user = User.standard
    
    var playlists = [PlaylistModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.        
        
        authMgr.requestNotificationCenterAuthorization { _ in }
        authMgr.registerForRemoteNotificationsIfNeeded()
        
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        
        setUpAlertController()
        
        print(user.id)
        print(user.phoneNumber)
        print(user.apnToken)
        
        loadPlaylistTitles()
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
    
    private func loadPlaylistTitles() {
        muzeClient.getUser(userId: user.id) { userModel in
            guard userModel != nil else { return }
            
            let userPlaylists = userModel!.sharedPlaylists + userModel!.ownedPlaylists
            self.muzeClient.getPlaylistTitles(playlistIds: userPlaylists) { playlistModels in
                self.playlists = playlistModels
                self.playlistTableView.reloadData()
            }
        }
    }
    
    private func setUpAlertController() {
        alert = UIAlertController(title: "Create playlist", message: nil, preferredStyle: .alert)
        
        let createAction = UIAlertAction(title: "Create", style: .default) { _ in
            let playlistName = self.alert!.textFields![0].text!
            self.muzeClient.createPlaylist(creatorId: self.user.id, title: playlistName) { error in
                guard error == nil else { return }
                self.loadPlaylistTitles()
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert!.addTextField { textField in
            textField.placeholder = "Playlist name"
        }
        
        alert!.addAction(createAction)
        alert!.addAction(cancelAction)
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlist, for: indexPath)
        cell.textLabel?.text = playlists[indexPath.row].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: .toPlaylistDetail, sender: playlists[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: IBAction methods
    
    @IBAction func createPlaylistButtonTapped(_ sender: Any) {
        createPlaylistButton.isEnabled = false
        
        guard alert != nil else {
            self.createPlaylistButton.isEnabled = true
            return
        }
        
        self.present(alert!, animated: true) {
            self.createPlaylistButton.isEnabled = true
        }
    }
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        let loginViewController = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: .login) as! LoginViewController
        self.present(loginViewController, animated: true) {
            self.user.clearLoginInfo()
        }
    }
}
