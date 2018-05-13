//
//  ReviewSectionView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 03/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ReviewSectionView: UIView {

    @IBOutlet weak var sortButton: UIButton!
    
    class func instanceFromNib() -> ReviewSectionView {
        return UINib(nibName: "ReviewSectionView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! ReviewSectionView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        //   fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}
