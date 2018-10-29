//
//  AuthorizationManager.swift
//  Muze
//
//  Created by Charles Gong on 6/17/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer
import UserNotifications
import Contacts

//  - TODO:
// Add request country code
// Add notification observers

class AuthorizationManager {
    static let shared = AuthorizationManager()
    
    private init() {}
    
    // MARK: Properties
    
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let contactStore = CNContactStore()
    
    private let musicServiceAuths: [MusicServiceProvider: MusicServiceAuth] = [
        .spotify: SpotifyAuth.shared,
        .appleMusic: AppleMusicAuth.shared
    ]
    
    private var musicServiceAuth: MusicServiceAuth? {
        return musicServiceAuths[musicServiceProvider]
    }
    
    var musicServiceProvider: MusicServiceProvider = .none
    
    // MARK: Music service auth methods
    
    func requestAuthorization(completion: @escaping () -> Void) {        
        musicServiceAuth?.requestAuthorization(completion: completion)
    }
    
    func getSession(completion: @escaping () -> Void) {
        musicServiceAuth?.getSession { error in
            self.handleError(error: error) {
               completion()
            }
        }
    }
    
    // MARK: Remote notifications
    
    func requestNotificationCenterAuthorization(completion: ((Bool) -> Void)?) {
        userNotificationCenter.getNotificationSettings() { settings in
            if settings.authorizationStatus == .notDetermined {
                self.userNotificationCenter.requestAuthorization(options: [.badge, .alert, .sound]) { granted, error in
                    completion?(granted)
                }
            }
        }
    }
    
    func registerForRemoteNotificationsIfNeeded() {
        if !UIApplication.shared.isRegisteredForRemoteNotifications {
            UIApplication.shared.registerForRemoteNotifications()
        }
    }
    
    // MARK: Contacts
    
    func requestContactsAuthorization(completion: @escaping (CNAuthorizationStatus) -> Void) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .notDetermined else {
            completion(CNContactStore.authorizationStatus(for: .contacts))
            return
        }
        
        contactStore.requestAccess(for: .contacts) { granted, error in
            completion(CNContactStore.authorizationStatus(for: .contacts))
        }
    }
    
    // Mark: Helpers
    
    private func handleError(error: Error?, completion: @escaping () -> Void) {
        guard error == nil else {
            print(error!.localizedDescription)
            return
        }
        
        completion()
    }
}
