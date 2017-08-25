//
//  PlaylistAddMusicViewController.swift
//  Muze
//
//  Created by Charles Gong on 8/11/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistAddMusicViewController: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    
    private let mainStoryboard = UIStoryboard(name: "Main", bundle: .main)
    
    var playlistId: String!
    var size: Int!
    
    private lazy var playlistAddPlaylistViewController: PlaylistAddPlaylistViewController = {
        let viewController = self.mainStoryboard.instantiateViewController(withIdentifier: .playlistAddPlaylist) as! PlaylistAddPlaylistViewController
        
        return viewController
    }()
    
    private lazy var playlistSearchMusicViewController: PlaylistSearchMusicViewController = {
        let viewController = self.mainStoryboard.instantiateViewController(withIdentifier: .playlistSearchMusic) as! PlaylistSearchMusicViewController
        
        return viewController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateView(index: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func add(childViewController child: UIViewController) {
        self.addChildViewController(child)
        
        child.view.frame = containerView.frame
        child.view.addConstraints(containerView.constraints)
        self.view.addSubview(child.view)
        
        child.didMove(toParentViewController: self)
    }
    
    private func remove(childViewController child: UIViewController) {
        child.willMove(toParentViewController: nil)
        
        child.view.removeFromSuperview()
        
        child.removeFromParentViewController()
    }
    
    private func updateView(index: Int) {
        switch(index) {
        case 0:
            remove(childViewController: playlistSearchMusicViewController)
            add(childViewController: playlistAddPlaylistViewController)
        case 1:
            remove(childViewController: playlistAddPlaylistViewController)
            add(childViewController: playlistSearchMusicViewController)
        default:
            break
        }
    }
    
    // MARK: IBAction methods
    
    @IBAction func segmentedControlChanged(_ sender: Any) {
        let segmentedControl = sender as! UISegmentedControl
        let selectedIndex = segmentedControl.selectedSegmentIndex
        
        updateView(index: selectedIndex)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
    }
}
