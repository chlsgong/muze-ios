//
//  AppleMusicAuth.swift
//  Muze
//
//  Created by Charles Gong on 10/14/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import Foundation
import StoreKit

class AppleMusicAuth: MusicServiceAuth {
    static let shared = AppleMusicAuth()
    
    private init() {}
    
    private let cloudServiceController = SKCloudServiceController()
    
    private let user = User.standard
    
    private var devToken: String { return user.appleMusicDevToken }
    
    // MARK: MusicServiceAuth protocol methods
    
    func requestAuthorization(completion: @escaping () -> Void) {
        requestCloudServiceAuthorization(completion: completion)
    }
    
    func getSession(completion: @escaping (Error?) -> Void) {
        requestAppleMusicUserToken(completion: completion)
    }
    
    // MARK: Authorization methods
    
    func requestCloudServiceAuthorization(completion: @escaping () -> Void) {
        let authorizationStatus = SKCloudServiceController.authorizationStatus()
        
        guard authorizationStatus == .notDetermined else {
            if authorizationStatus == .authorized {
                completion()
            }
            return
        }
        
        SKCloudServiceController.requestAuthorization { authorizationStatus in
            // TODO: make sure it's not asynchronous
            if authorizationStatus == .authorized {
                completion()
            }
        }
    }
    
    func requestAppleMusicUserToken(completion: @escaping (Error?) -> Void) {
        cloudServiceController.requestUserToken(forDeveloperToken: devToken) { userToken, error in
            if error == nil {
                self.user.appleMusicUserToken = userToken!
            }
            DispatchQueue.main.async {
                completion(error)
            }
        }
    }
}
