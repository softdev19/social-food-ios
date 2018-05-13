
//
//  SearchRestaurantTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 18/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class SearchRestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
