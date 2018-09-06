//
//  NavigationManager.swift
//  Muze
//
//  Created by Charles Gong on 8/28/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import UIKit

class NavigationManager {
    static let shared = NavigationManager()
    
    private var rootViewController: RootViewController
    
    private init() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        rootViewController = appDelegate.window!.rootViewController as! RootViewController
    }
    
    func move(toViewController viewController: Identifier.ViewController) {
        switch(viewController) {
        case .splash: rootViewController.moveToSplash()
        case .login: rootViewController.moveToLogin()
        default: print("no navigation")
        }
    }
    
    func move(toTabBarController tabBarController: Identifier.TabBarController) {
        switch(tabBarController) {
        case .mainTabBar: rootViewController.moveToMain()
        }
    }
}
