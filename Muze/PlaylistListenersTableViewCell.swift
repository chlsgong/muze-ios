//
//  PlaylistListenersTableViewCell.swift
//  Muze
//
//  Created by Charles Gong on 8/3/17.
//  Copyright © 2017 Charles Gong. All rights reserved.
//

import UIKit

class PlaylistListenersTableViewCell: UITableViewCell {
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    var delegate: RemovableCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func removeButtonTapped(_ sender: Any) {
        delegate?.removeButtonTapped(self)
    }
}
