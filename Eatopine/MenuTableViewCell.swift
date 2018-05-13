//
//  MenuTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 21/09/15.
//  Copyright © 2015 Eatopine. All rights reserved.
//

import UIKit

class MenuTableViewCell: UITableViewCell {

    @IBOutlet weak var dish_photo: UIImageView!
    @IBOutlet weak var rating: TPFloatRatingView!
    @IBOutlet weak var lblDishName: UILabel!
    @IBOutlet weak var lblDishNumberOfReviews: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        if rating != nil {
            rating.setupForEatopineSmall()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
