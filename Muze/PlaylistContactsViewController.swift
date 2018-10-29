//
//  PlaylistContactsViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit
import Contacts

//  - TODO:
// Exclude existing numbers
// Add hypens in between numbers

class PlaylistContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private let authMgr = AuthorizationManager.shared
    private let muzeClient = MuzeClient()
    
    var playlistId: String!
    var contacts = [Contact]()
    var selectedContacts = [Contact]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        doneButton.isEnabled = false
        
        authMgr.requestContactsAuthorization { authorizationStatus in
            if authorizationStatus == .authorized {
                Utility.fetchContacts { contacts, error in
                    if error == nil {
                        self.contacts = contacts
                    }
                    
                    self.contactsTableView.reloadData()
                }
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistContactsCell, for: indexPath) as! PlaylistContactsTableViewCell
        let contact = contacts[indexPath.row]
        
        let firstName = contact.firstName
        let lastName = contact.lastName
        let phoneNumber = contact.phoneNumber
        
        cell.nameLabel.text = "\(firstName) \(lastName)"
        cell.phoneNumberLabel.text = phoneNumber
        cell.checkBoxView.layer.cornerRadius = 3
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlaylistContactsTableViewCell
        cell.checkBoxView.backgroundColor = UIColor.blue
        
        selectedContacts.append(contacts[indexPath.row])
        doneButton.isEnabled = true
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! PlaylistContactsTableViewCell
        cell.checkBoxView.backgroundColor = UIColor.lightGray
        
        selectedContacts = selectedContacts.filter {
            $0.id != contacts[indexPath.row].id
        }
        if selectedContacts.isEmpty {
            doneButton.isEnabled = false
        }
    }
    
    // MARK: IBAction methods
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        doneButton.isEnabled = false
        
        let phoneNumbers = selectedContacts.map { $0.phoneNumber }
        muzeClient.addPlaylistUsers(playlistId: playlistId, phoneNumbers: phoneNumbers) { error in
            self.navigationController?.popViewController(animated: true)
        }
    }
    
}
