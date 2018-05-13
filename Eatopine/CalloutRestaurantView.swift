//
//  CalloutRestaurantView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

private let calloutFrame = CGRectMake(0, 0, 190, 63)

class CalloutRestaurantView: UIView {
    
    private var view: UIView!
    @IBOutlet weak private var lblName: UILabel!
    @IBOutlet weak private var imgRestaurant: UIImageView!
    @IBOutlet weak private var rating: TPFloatRatingView!
    @IBOutlet weak private var lblDish: UILabel!
    
    var restaurant: EPRestaurant!
    
    init(restaurant:EPRestaurant) {
        
        super.init(frame: calloutFrame)
        xibSetup()
        self.restaurant = restaurant
        
        rating.setupForAnnotation()
        lblName.text = restaurant.name
        imgRestaurant.sd_setImageWithURL(NSURL(string: restaurant.best_dish_photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        rating.rating = CGFloat(restaurant.rating)
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
        let nib = UINib(nibName: "CalloutRestaurantView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
}
