//
//  UIUtil.swift
//  Muze
//
//  Created by Charles Gong on 6/18/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class UIUtil {
    class func setInitialViewController(window: UIWindow) {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        
        if User.standard.isLoggedIn {
            window.rootViewController = storyboard.instantiateViewController(withIdentifier: .mainTabBar)
        }
        else {
            window.rootViewController = storyboard.instantiateInitialViewController()
        }
        window.makeKeyAndVisible()
    }
    
    // FIX: check root vc for current vc
    class func getVisibleViewController() -> UIViewController? {
        return UIApplication.shared.keyWindow?.rootViewController
    }
}

extension UIViewController {
    func performSegue(withIdentifier id: Identifier.Segue, sender: Any?) {
        self.performSegue(withIdentifier: id.rawValue, sender: sender)
    }
}

extension UIStoryboardSegue {
    func isIdentified(byId id: Identifier.Segue) -> Bool {
        return self.identifier == id.rawValue
    }
}

extension UITableView {
    func dequeueReusableCell(withIdentifier id: Identifier.Cell, for indexPath: IndexPath) -> UITableViewCell {
        return self.dequeueReusableCell(withIdentifier: id.rawValue, for: indexPath)
    }
}

extension UIStoryboard {
    func instantiateViewController(withIdentifier id: Identifier.ViewController) -> UIViewController {
        return self.instantiateViewController(withIdentifier: id.rawValue)
    }
    
    func instantiateViewController(withIdentifier id: Identifier.TabBarController) -> UITabBarController {
        return self.instantiateViewController(withIdentifier: id.rawValue) as! UITabBarController
    }
}
