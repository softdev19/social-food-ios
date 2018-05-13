//
//  CalloutDishView.swift
//  Eatopine
//
//  Created by JCB on 10/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

private let calloutFrame = CGRectMake(0, 0, 190, 63)

class CalloutDishView: UIView {
    
    private var view: UIView!
    @IBOutlet weak private var lblName: UILabel!
    @IBOutlet weak private var imgDish: UIImageView!
    @IBOutlet weak private var rating: TPFloatRatingView!
    @IBOutlet weak private var lblRestaurant: UILabel!
    
    var dish: EPSearchDish!
    
    init(dish:EPSearchDish) {
        
        super.init(frame: calloutFrame)
        xibSetup()
        self.dish = dish
        
        rating.setupForAnnotation()
        lblName.text = dish.dishName
        imgDish.sd_setImageWithURL(NSURL(string: dish.dishPhoto), placeholderImage: UIImage(named: "dish_placeholder"))
        rating.rating = CGFloat(dish.vote)
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "CalloutDishView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}

