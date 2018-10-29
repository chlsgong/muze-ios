//
//  App.swift
//  Muze
//
//  Created by Charles Gong on 10/19/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation

class App {
    class func initialize() {
        // Load from user defaults
        User.standard.retrieveLoginInfo()
        AuthorizationManager.shared.musicServiceProvider = User.standard.serviceProvider
    }
}
