//
//  RestaurantTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 01/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class RestaurantTableViewCell: UITableViewCell {

    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var bestDishIcon: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var rating: TPFloatRatingView!
    @IBOutlet weak var lblRatingNumber: UILabel!
    
    
    @IBOutlet weak var lblAddress: UILabel!
    @IBOutlet weak var lblDish: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if rating != nil {
            rating.setupForEatopineSmall()
        }
        
        
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
