//
//  ActivityTableViewCell.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/10/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {

    @IBOutlet weak var typeIcon: UIImageView!
    @IBOutlet weak var firstName: UILabel!
    @IBOutlet weak var dishName: UILabel!
    
    
    @IBOutlet weak var review: UILabel!
    
    @IBOutlet weak var fullComent: UILabel!
    
    @IBOutlet weak var likesCount: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    
    @IBOutlet weak var timing: UILabel!
    
    @IBOutlet weak var activityImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
