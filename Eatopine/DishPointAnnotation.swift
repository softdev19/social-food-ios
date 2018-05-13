//
//  DishPointAnnotation.swift
//  Eatopine
//
//  Created by  on 10/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import MapKit

class DishPointAnnotation: MKPointAnnotation {
    
    var dish: EPMapDish!
    
    override init () {
        super.init()
    }
    
    convenience init(dish:EPMapDish,coordinate:CLLocationCoordinate2D) {
        self.init()
        self.dish = dish
        self.coordinate = coordinate
    }
}
