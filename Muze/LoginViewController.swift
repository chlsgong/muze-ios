//
//  LoginViewController.swift
//  Muze
//
//  Created by Charles Gong on 6/6/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    private let authMgr = AuthorizationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // have to swipe up for segue bug
    @IBAction func appleMusicButtonTapped(_ sender: Any) {
        authMgr.requestCloudServiceAuthorization { authorizationStatus in
            if authorizationStatus == .authorized {
                self.authMgr.requestMediaLibraryAuthorization { authorizationStatus in
                    if authorizationStatus == .authorized {
                        self.performSegue(withIdentifier: .toConnect, sender: nil)
                    }
                    else {
                        // handle status
                    }
                }
            }
            else {
                // handle status
            }
        }
    }
    
}
