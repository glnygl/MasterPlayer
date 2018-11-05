//
//  ListUsersTableViewCell.swift
//  MasterPlayer
//
//  Created by Glny Gl on 23.10.2018.
//  Copyright © 2018 Glny Gl. All rights reserved.
//

import UIKit

class ListUsersTableViewCell: UITableViewCell {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userFollowerLabel: UILabel!
    @IBOutlet weak var userTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
}
