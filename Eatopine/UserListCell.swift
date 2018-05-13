//
//  UserListCell.swift
//  Eatopine
//
//  Created by Tony on 9/21/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class UserListCell: UITableViewCell {
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var lbUserName: UILabel!
    @IBOutlet weak var lbDisplayName: UILabel!
    @IBOutlet weak var btnFollow: UIButton!
    @IBOutlet weak var lblPhotos: UILabel!
}
