//
//  EPRestaurantInfo.swift
//  Eatopine
//
//  Created by Borna Beakovic on 13/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper

class EPRestaurantInfo: Mappable {
   
    var tel = ""
    var fax = ""
    var website = ""
    var email = ""
    
    
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        tel    <- map["tel"]
        fax    <- map["fax"]
        website    <- map["website"]
        email    <- map["email"]
    }
    
}
