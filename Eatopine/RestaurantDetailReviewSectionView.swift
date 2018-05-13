//
//  RestaurantDetailReviewSectionView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 07/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class RestaurantDetailReviewSectionView: UIView {

    class func instanceFromNib() -> RestaurantDetailReviewSectionView {
        return UINib(nibName: "RestaurantDetailReviewSectionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! RestaurantDetailReviewSectionView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //   fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
}
