//
//  LoginViewController.swift
//  Muze
//
//  Created by Charles Gong on 6/6/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var appleMusicButton: UIButton!
    @IBOutlet weak var spotifyButton: UIButton!
    
    private let authMgr = AuthorizationManager()
    private let user = User.standard
    private let musicMgr = MusicManager.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func spotifyAuthorizationCallback(isAuthorized: Bool) {
        if isAuthorized {
            self.setServiceProvider(serviceProvider: .spotify)
             performSegue(withIdentifier: .toConnect, sender: nil)
        }
        else {
            // handle unauthorized
            print("spotify unauthorized")
        }
    }
    
    private func setServiceProvider(serviceProvider: ServiceProvider) {
        self.musicMgr.serviceProvider = serviceProvider
        self.user.serviceProvider = serviceProvider
    }
    
    // MARK: IBAction methods
    
    @IBAction func appleMusicButtonTapped(_ sender: Any) {
        appleMusicButton.isEnabled = false
        
        authMgr.requestCloudServiceAuthorization { authorizationStatus in
            if authorizationStatus == .authorized {
                self.authMgr.requestMediaLibraryAuthorization { authorizationStatus in
                    if authorizationStatus == .authorized {
                        self.setServiceProvider(serviceProvider: .appleMusic)
                        
                        self.performSegue(withIdentifier: .toConnect, sender: nil)
                        self.appleMusicButton.isEnabled = true
                    }
                    else {
                        // handle status
                        
                        self.appleMusicButton.isEnabled = true
                    }
                }
            }
            else {
                // handle status
                
                self.appleMusicButton.isEnabled = true
            }
        }
    }
    
    @IBAction func spotifyButtonTapped(_ sender: Any) {
        spotifyButton.isEnabled = false
        
        authMgr.requestSpotifyAuthorization {
            self.spotifyButton.isEnabled = true
        }
    }
}
