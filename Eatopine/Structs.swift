//
//  Structs.swift
//  Eatopine
//
//  Created by Borna Beakovic on 03/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import Foundation


struct CityDetails {
    var name: String
    var state: String
    var latitude: Float
    var longitude: Float
    
    
    init(name: String, state: String, lat:Float, lng: Float) {
        self.name = name
        self.state = state
        self.latitude = lat
        self.longitude = lng
    }
}