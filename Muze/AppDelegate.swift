//
//  AppDelegate.swift
//  Muze
//
//  Created by Charles Gong on 6/6/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let muzeClient = MuzeClient()
    let user = User.standard
    let musicMgr = MusicManager.shared

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // ************ TEST AREA BEGIN ************
        
        // let appleMusicClient = AppleMusicClient.shared
        // appleMusicClient.getSong()
        
        // muzeClient.helloWorld()
        
        
        // ************* TEST AREA END *************
        
        App.initialize()
        
        return true
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let apnToken = deviceToken.reduce("", {$0 + String(format: "%02X", $1)})
        print("APNs device token: \(apnToken)")
        
        // Store APN token
        user.apnToken = apnToken
        
        muzeClient.updateAPNToken(userId: user.id, apnToken: apnToken) { error in
            if error == nil {
                print("ERROR")
            }
        }
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        // Parse code
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)
        
        var isAuthorized = false
        if let name = urlComponents?.queryItems?.first?.name {
            isAuthorized = name == SpotifyAuth.shared.responseType
            
            if isAuthorized {
                let code = urlComponents?.queryItems?.first?.value
                SpotifyAuth.shared.code = code
            }
        }
        
        if let visibleViewController = UIUtil.getVisibleViewController() as? LoginViewController {
            visibleViewController.spotifyAuthorizationCallback(isAuthorized: isAuthorized)
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

