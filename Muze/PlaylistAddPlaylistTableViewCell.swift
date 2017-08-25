//
//  PlaylistAddPlaylistTableViewCell.swift
//  Muze
//
//  Created by Charles Gong on 8/17/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistAddPlaylistTableViewCell: UITableViewCell {
    @IBOutlet weak var playlistTitle: UILabel!
    @IBOutlet weak var addPlaylistLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
