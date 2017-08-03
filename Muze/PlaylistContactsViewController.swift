//
//  PlaylistContactsViewController.swift
//  Muze
//
//  Created by Charles Gong on 7/31/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var contactsTableView: UITableView!
    
    var playlistId: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: UITableViewDelegate methods
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: .playlistContactsCell, for: indexPath)
        return cell
    }
}
