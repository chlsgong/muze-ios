//
//  PlaylistListenersViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

// - TODO:
// Exclude existing numbers
// Add hyphens in between numbers

class PlaylistListenersViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var addPhoneNumberButton: UIButton!
    @IBOutlet weak var addFromContactsButton: UIButton!
    @IBOutlet weak var listenersTableView: UITableView!
    
    private let muzeClient = MuzeClient()
    
    var playlistId: String!
    var playlistUsers = [(id: String, phoneNumber: String)]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        phoneNumberTextField.delegate = self
        
        listenersTableView.delegate = self
        listenersTableView.dataSource = self
        
        addPhoneNumberButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        reloadTableView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        phoneNumberTextField.resignFirstResponder()
        super.touchesBegan(touches, with: event)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.isIdentified(byId: .toContacts) {
            if let destination = segue.destination as? PlaylistContactsViewController {
                destination.playlistId = playlistId
            }
        }
    }
    
 func reloadTableView() {
        muzeClient.getPlaylistUsers(playlistId: playlistId) { users in
            self.playlistUsers = users
            self.listenersTableView.reloadData()
        }
    }
    
    // MARK: UITextFieldDelegate methods
    
    // bug after changing character in the middle
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
    
    // UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlistUsers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistListenersCell, for: indexPath) as! PlaylistListenersTableViewCell
        let playlistUser = playlistUsers[indexPath.row]
        
        cell.selectionStyle = .none
        cell.phoneNumberLabel.text = playlistUser.phoneNumber
        cell.userId = playlistUser.id
        cell.viewController = self
        
        return cell
    }
    
    // IBAction methods
    
    @IBAction func addPhoneNumberButtonTapped(_ sender: Any) {
        addPhoneNumberButton.isEnabled = false
        
        let phoneNumber = phoneNumberTextField.text!.replacingOccurrences(of: "-", with: "")
        
        muzeClient.addPlaylistUsers(playlistId: playlistId, phoneNumbers: [phoneNumber]) { error in
            self.reloadTableView()
            self.addPhoneNumberButton.isEnabled = true
        }
    }

}
