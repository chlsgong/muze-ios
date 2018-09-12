//
//  RootViewController.swift
//  Muze
//
//  Created by Charles Gong on 8/28/18.
//  Copyright © 2018 Charles Gong. All rights reserved.
//

import UIKit

class RootViewController: UIViewController {
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
    
    private(set) var currentViewController: UIViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        moveToSplash()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func moveToSplash() {
        currentViewController = mainStoryboard.instantiateViewController(withIdentifier: .splash) as! SplashViewController
        addNewView(viewController: currentViewController!)
    }
    
    func moveToLogin() {
        let loginViewController = mainStoryboard.instantiateViewController(withIdentifier: .login) as! LoginViewController
        replaceCurrentView(withViewController: loginViewController)
    }
    
    func moveToMain() {
        let mainTabBar = mainStoryboard.instantiateViewController(withIdentifier: .mainTabBar)
        replaceCurrentView(withViewController: mainTabBar)
    }
    
    // MARK: Helpers
    
    private func replaceCurrentView(withViewController viewController: UIViewController) {
        addNewView(viewController: viewController)
        removeCurrentView()
        currentViewController = viewController
    }
    
    private func addNewView(viewController: UIViewController) {
        self.addChildViewController(viewController)
        viewController.view.frame = self.view.bounds
        self.view.addSubview(viewController.view)
        viewController.didMove(toParentViewController: self)
    }
    
    private func removeCurrentView() {
        currentViewController!.willMove(toParentViewController: nil)
        currentViewController!.view.removeFromSuperview()
        currentViewController!.removeFromParentViewController()
    }
}
