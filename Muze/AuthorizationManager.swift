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
    private let cloudServiceController = SKCloudServiceController()
    private var cloudServiceCapabilities = SKCloudServiceCapability()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let contactStore = CNContactStore()
    private let musicClient = MusicClient()
    
    private var cloudServiceStorefrontCountryCode = "us"
    
    // Apple Music authorization
    
    func requestCloudServiceAuthorization(completion: @escaping (SKCloudServiceAuthorizationStatus) -> Void) {
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else {
            completion(SKCloudServiceController.authorizationStatus())
            return
        }

        SKCloudServiceController.requestAuthorization { authorizationStatus in
            switch authorizationStatus {
            case .authorized:
                self.requestCloudServiceCapabilities()
            default:
                break
            }
            
            completion(authorizationStatus)
        }
    }
    
    private func requestCloudServiceCapabilities() {
        cloudServiceController.requestCapabilities { cloudServiceCapability, error in
            guard error == nil else { /* handle error */ return }
            
            self.cloudServiceCapabilities = cloudServiceCapability
        }
    }
    
    func requestMediaLibraryAuthorization(completion: @escaping (MPMediaLibraryAuthorizationStatus) -> Void) {
        guard MPMediaLibrary.authorizationStatus() == .notDetermined else {
            completion(MPMediaLibrary.authorizationStatus())
            return
        }
        
        MPMediaLibrary.requestAuthorization { authorizationStatus in
            completion(authorizationStatus)
        }
    }
    
    func requestUserToken(completion: @escaping (String?, Error?) -> Void) {
        let token = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IkU5R01WQUQ1RFQifQ.eyJpc3MiOiJITVlDTkU1OVMyIiwiaWF0IjoxNTMwNDY5ODU1LCJleHAiOjE1MzgzNTgzNTV9.HiQa2wL3Wu0dLkpZ0DxUX-Ek1abO2Hu3aTWz3-_8zDmjecRhVKgb5DZwFWueNALzne9WeGkI6OjdbLx0n9KxVg"
        
        if #available(iOS 11.0, *) {
            cloudServiceController.requestUserToken(forDeveloperToken: token) { userToken, error in
                completion(userToken, error)
            }
        } else {
            // Fallback on earlier versions
            cloudServiceController.requestPersonalizationToken(forClientToken: token) { userToken, error in
                completion(userToken, error)
            }
        }
    }
    
    func availableCloudServiceCapabilities() -> [SKCloudServiceCapability] {        
        var availableCapabilities = [SKCloudServiceCapability]()
        
        if cloudServiceCapabilities.contains(.addToCloudMusicLibrary) {
            availableCapabilities.append(.addToCloudMusicLibrary)
        }
        if cloudServiceCapabilities.contains(.musicCatalogPlayback) {
            availableCapabilities.append(.musicCatalogPlayback)
        }
        if cloudServiceCapabilities.contains(.musicCatalogSubscriptionEligible) {
            availableCapabilities.append(.musicCatalogSubscriptionEligible)
        }
        
        return availableCapabilities
    }
    
    // Spotify authorization
    
    func requestSpotifyAuthorization(completion: @escaping () -> Void) {        
        musicClient.authorizeSpotify(completion: completion)
    }
    
    // change to match contacts (return type)
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
    
    func requestContactsAuthorization(completion: @escaping (CNAuthorizationStatus) -> Void) {
        guard CNContactStore.authorizationStatus(for: .contacts) == .notDetermined else {
            completion(CNContactStore.authorizationStatus(for: .contacts))
            return
        }
        
        contactStore.requestAccess(for: .contacts) { granted, error in
            completion(CNContactStore.authorizationStatus(for: .contacts))
        }
    }
}

extension SKCloudServiceCapability {
    func capabilityString() -> String {
        switch self {
        case .addToCloudMusicLibrary:
            return "Add To Cloud Music Library"
        case .musicCatalogPlayback:
            return "Music Catalog Playback"
        case .musicCatalogSubscriptionEligible:
            return "Music Catalog Subscription Eligible"
        default:
            return ""
        }
    }
}
