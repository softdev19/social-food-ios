//
//  ReviewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 01/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    @IBOutlet weak var author_photo: UIImageView!
    @IBOutlet weak var rating: TPFloatRatingView!
    @IBOutlet weak var lblAuthor_name: UILabel!
    @IBOutlet weak var lblAuthor_points: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblReview: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        if rating != nil {
            rating.setupForEatopineSmall()
        }
    }
}
