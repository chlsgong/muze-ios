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
    
    private let authMgr = AuthorizationManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setServiceProvider(serviceProvider: MusicServiceProvider) {
        authMgr.musicServiceProvider = serviceProvider
    }
    
    private func segueToConnect() {
        self.performSegue(withIdentifier: .toConnect, sender: nil)
    }
    
    func spotifyAuthorizationCallback(isAuthorized: Bool) {
        if isAuthorized {
            segueToConnect()
        }
        else {
            // handle unauthorized
            print("spotify unauthorized")
        }
    }
    
    // MARK: IBAction methods
    
    @IBAction func appleMusicButtonTapped(_ sender: Any) {
        appleMusicButton.isEnabled = false
        
        setServiceProvider(serviceProvider: .appleMusic)
        authMgr.requestAuthorization {
            self.segueToConnect()
            self.appleMusicButton.isEnabled = true
        }
        
//        authMgr.requestCloudServiceAuthorization { authorizationStatus in
//            if authorizationStatus == .authorized {
//                self.authMgr.requestMediaLibraryAuthorization { authorizationStatus in
//                    DispatchQueue.main.async {
//                        if authorizationStatus == .authorized {
//                            self.setServiceProvider(serviceProvider: .appleMusic)
//
//                            self.performSegue(withIdentifier: .toConnect, sender: nil)
//                            self.appleMusicButton.isEnabled = true
//                        }
//                        else {
//                            // handle status
//
//                            self.appleMusicButton.isEnabled = true
//                        }
//                    }
//                }
//            }
//            else {
//                // handle status
//
//                self.appleMusicButton.isEnabled = true
//            }
//        }
    }
    
    @IBAction func spotifyButtonTapped(_ sender: Any) {
        spotifyButton.isEnabled = false
        
        setServiceProvider(serviceProvider: .spotify)
        authMgr.requestAuthorization {
            self.spotifyButton.isEnabled = true
        }
    }
}
