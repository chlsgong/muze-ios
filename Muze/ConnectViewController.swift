//
//  ConnectViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/25/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class ConnectViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    private let muzeClient = MuzeClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if phoneNumberTextField.text!.isEmpty {
            sendButton.isEnabled = false
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberTextField.resignFirstResponder()
        
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isIdentified(byId: .toConfirm) {
            if let destination = segue.destination as? ConfirmViewController {
                destination.phoneNumber = phoneNumberTextField.text!
            }
        }
    }
    
    // MARK: UITextFieldDelegate Methods
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        let lenLimit = 12

        if string.isEmpty {
            guard range.length == 1 else { return false }
            
            if range.location == 4 || range.location == 8 {
                let newString = text.dropLast(2)
                textField.text = String(newString)
                return false
            }
            if range.location == lenLimit - 1 {
                sendButton.isEnabled = false
            }
        }
        else {
            guard string.isNumeric() else { return false }
            guard string.characters.count <= 1 else { return false }
            guard range.location < lenLimit else { return false }
            
            if range.location == 3 || range.location == 7 {
                textField.text = "\(textField.text!)-\(string)"
                return false
            }
            if range.location == lenLimit - 1 {
                sendButton.isEnabled = true
            }
        }
        
        return true
    }
    
    // MARK: IBAction Methods
    
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendButton.isEnabled = false
        
        let phoneNumber = phoneNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        
        muzeClient.requestVerificationCode(phoneNumber: phoneNumber) { error in
            self.sendButton.isEnabled = true
        }
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }
    
}
