//
//  ConfirmViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class ConfirmViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var codeConfirmationTextField: UITextField!
    @IBOutlet weak var resendButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    private let authMgr = AuthorizationManager()
    private let navMgr = NavigationManager.shared
    private let muzeClient = MuzeClient()
    private let musicClient = MusicClient()
    private let user = User.standard
    
    var phoneNumber: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        codeConfirmationTextField.delegate = self
        
        doneButton.isEnabled = false
        
        phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: Helpers
    
    private func moveToMainTabBarController() {
        self.navMgr.move(toTabBarController: .mainTabBar)
        self.navigationController!.dismiss(animated: false, completion: nil)
    }
    
    // MARK: UITextFieldDelegate methods
    
    // FIX: bug after changing character in the middle
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let lenLimit = 6
        
        if string.isEmpty {
            guard range.length == 1 else { return false }
            
            if range.location == lenLimit - 1 {
                doneButton.isEnabled = false
            }
        }
        else {
            guard string.isNumeric() else { return false }
            guard string.count <= 1 else { return false }
            guard range.location < lenLimit else { return false }
            
            if range.location == lenLimit - 1 {
                doneButton.isEnabled = true
            }
        }
        
        return true
    }
    
    // MARK: UIAction methods
    
    @IBAction func resendButtonTapped(_ sender: Any) {
        resendButton.isEnabled = false
        
        muzeClient.requestVerificationCode(phoneNumber: phoneNumber) { error in
            self.resendButton.isEnabled = true
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneButton.isEnabled = false
        
        muzeClient.checkVerificationCode(phoneNumber: phoneNumber, code: codeConfirmationTextField.text!, apnToken: user.apnToken) { userId in
            if userId != nil {
                self.user.id = userId!
                self.user.phoneNumber = self.phoneNumber
                self.user.isLoggedIn = true
                
                if self.user.serviceProvider == .spotify {
                    self.musicClient.requestSpotifyTokens() { accessToken, expiresIn, refreshToken, error in
                        if error == nil {
                            self.user.spotifyRefreshToken = refreshToken!
                            SpotifyAuth.accessToken = accessToken
                            
                            /* Move to PlaylistViewController and store in user defaults */
                            self.musicClient.getCurrentUser() { userId, error in
                                if error == nil {
                                    SpotifyAuth.userId = userId
                                    self.moveToMainTabBarController()
                                }
                                else {
                                    print("error", error!)
                                }
                            }
                        }
                        else {
                            print("error", error!)
                        }
                    }
                }
                else {
                    self.moveToMainTabBarController()
                }
            }
            
            self.doneButton.isEnabled = true
        }
    }

}
