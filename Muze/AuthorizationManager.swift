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

//  - TODO:
// Add request country code
// Add notification observers

class AuthorizationManager {
    private let cloudServiceController = SKCloudServiceController()
    private var cloudServiceCapabilities = SKCloudServiceCapability()
    
    private var cloudServiceStorefrontCountryCode = "us"
    
    init() {
        if SKCloudServiceController.authorizationStatus() == .authorized {
            requestCloudServiceCapabilities()
        }
    }
    
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
