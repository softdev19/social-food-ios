//
//  FollowersTableViewCell.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/10/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class FollowersTableViewCell: UITableViewCell {

    @IBOutlet weak var images: UIImageView!
    @IBOutlet weak var Lastname: UILabel!
    @IBOutlet weak var firstNAme: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
