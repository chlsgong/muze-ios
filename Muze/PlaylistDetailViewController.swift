//
//  PlaylistDetailViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var playlistDetailTableView: UITableView!
    
    var playlistModel: PlaylistModel!
    var playlist = [Song]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = playlistModel.title
        
        // get playlist data
        // connect to socket
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
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistDetailCell, for: indexPath) as! PlaylistDetailTableViewCell
        cell.songTitleLabel.text = playlist[indexPath.row].title
        cell.songArtistLabel.text = playlist[indexPath.row].artist
        
        return cell
    }

}
