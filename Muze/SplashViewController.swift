//
//  SplashViewController.swift
//  Muze
//
//  Created by Charles Gong on 8/28/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    private let navMgr = NavigationManager.shared
    private let user = User.standard
    private let musicClient = MusicClient()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // TODO: find a way to make network call in viewDidLoad and move VC in here
        self.moveToViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: Helpers
    
    private func moveToViewController() {
        // TODO: simplify conditionals
        if user.isLoggedIn {
            requestAccessToken {
                self.navMgr.move(toTabBarController: .mainTabBar)
            }
        }
        else {
            navMgr.move(toViewController: .login)
        }
    }
    
    private func requestAccessToken(completion: @escaping () -> Void) {
        if user.serviceProvider == .spotify {
            musicClient.requestSpotifyAccessToken(refreshToken: user.spotifyRefreshToken) { error in
                if error == nil {
                    completion()
                }
            }
        }
        else if user.serviceProvider == .appleMusic {
            completion()
        }
    }
}
