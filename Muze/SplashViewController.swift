//
//  SplashViewController.swift
//  Muze
//
//  Created by Charles Gong on 8/28/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {
    let navMgr = NavigationManager.shared
    let user = User.standard

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print(user.isLoggedIn)
        
        if user.isLoggedIn {
            navMgr.move(toTabBarController: .mainTabBar)
        }
        else {
            navMgr.move(toViewController: .login)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
