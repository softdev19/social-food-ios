//
//  StaticMapCalloutView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 18/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class StaticMapCalloutView: UIView {

    @IBOutlet weak var lblName: UILabel!
    
    
    class func instanceFromNib() -> StaticMapCalloutView {
        return UINib(nibName: "StaticMapCalloutView", bundle: nil).instantiateWithOwner(nil, options: nil)[0] as! StaticMapCalloutView
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
