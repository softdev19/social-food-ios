//
//  RestaurantPointAnnotation.swift
//  Eatopine
//
//  Created by Borna Beakovic on 15/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import MapKit

class RestaurantPointAnnotation: MKPointAnnotation {
   
    var restaurant: EPRestaurant!
    
    override init () {
        super.init()
    }
    
    convenience init(restaurant:EPRestaurant,coordinate:CLLocationCoordinate2D) {
        self.init()
        self.restaurant = restaurant
        self.coordinate = coordinate
    }
}
