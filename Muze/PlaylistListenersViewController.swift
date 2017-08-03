//
//  PlaylistListenersViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistListenersViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addPhoneNumberButton: UIButton!
    @IBOutlet weak var addFromContactsButton: UIButton!
    @IBOutlet weak var listenersTableView: UITableView!
    
    let muzeClient = MuzeClient()
    
    var playlistId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        phoneNumberTextField.delegate = self
        
        addPhoneNumberButton.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isIdentified(byId: .toContacts) {
            if let destination = segue.destination as? PlaylistContactsViewController {
                destination.playlistId = playlistId
            }
        }
    }
    
    // MARK: UITextFieldDelegate methods
    
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
                addPhoneNumberButton.isEnabled = false
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
                addPhoneNumberButton.isEnabled = true
            }
        }
        
        return true
    }
    
    // IBAction methods
    
    @IBAction func addPhoneNumberButtonTapped(_ sender: Any) {
        addPhoneNumberButton.isEnabled = false
        
        let phoneNumber = phoneNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        
        muzeClient.addPlaylistUsers(playlistId: playlistId, phoneNumbers: [phoneNumber]) { error in
            self.addPhoneNumberButton.isEnabled = true
        }
    }

}
