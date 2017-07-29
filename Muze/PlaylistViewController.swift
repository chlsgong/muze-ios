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

class PlaylistViewController: UIViewController {
    private let authMgr = AuthorizationManager()
    
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
        
        authMgr.requestNotificationCenterAuthorization(completion: nil)
        authMgr.registerForRemoteNotificationsIfNeeded()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

