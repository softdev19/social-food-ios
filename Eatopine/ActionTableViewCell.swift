//
//  ActionTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 05/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ActionTableViewCell: UITableViewCell {

    @IBOutlet weak var photoView: ActivityIndicatorImageView!
    @IBOutlet weak var rating: TPFloatRatingView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
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
