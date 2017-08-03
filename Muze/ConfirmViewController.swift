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
    
    private let muzeClient = MuzeClient()
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
    
    // MARK: UITextFieldDelegate methods
    
    // bug after changing character in the middle
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
            guard string.characters.count <= 1 else { return false }
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
                self.user.updateLoginInfo(userId: userId!, apnToken: self.user.apnToken, phoneNumber: self.phoneNumber)
                self.performSegue(withIdentifier: .toTabBar, sender: nil)
            }
            
            self.doneButton.isEnabled = true
        }
    }

}
