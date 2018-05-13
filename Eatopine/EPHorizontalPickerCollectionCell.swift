//
//  EPHorizontalPickerCollectionCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class EPHorizontalPickerCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    @IBOutlet weak var btnRemove: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
