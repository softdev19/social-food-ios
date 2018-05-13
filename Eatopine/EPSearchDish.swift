//
//  EPSearchDish.swift
//  Eatopine
//
//  Created by  on 10/19/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPSearchDish: Mappable {
    var restaurantName = ""
    var vote: Float = 0
    var dishName = ""
    var restaurant_id = 0
    var latitude: Float = 0
    var longitude: Float = 0
    var price: Float = 0
    var id = 0
    var dish_photo = ""
    var distance: Float = 0
    
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
        let transformFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
            // transform value from String? to Float?
            return value?.floatValue
            }, toJSON: { (value: Float?) -> String? in
                // transform value from Float? to String?
                if let value = value {
                    return nf.stringFromNumber(value)
                }
                return nil
        })
        
        let transformInt = TransformOf<Int, String>(fromJSON: { (value: String?) -> Int? in
            // transform value from String? to Int?
            if value != nil{
                return Int(value!)
            }else{
                return 0
            }
            
            }, toJSON: { (value: Int?) -> String? in
                // transform value from Int? to String?
                if let value = value {
                    return String(value)
                }
                return nil
        })
        
        restaurantName  <- map["restaurant_name"]
        vote            <- (map["vote"], transformFloat)
        dishName        <- map["dish_name"]
        restaurant_id              <- (map["restaurant_id"], transformInt)
        latitude        <- (map["latitude"], transformFloat)
        longitude       <- (map["longitude"], transformFloat)
        price           <- (map["price"], transformFloat)
        id              <- (map["dish_id"], transformInt)
        dish_photo      <- map["dish_photo"]
        distance        <- (map["distance"], transformFloat)
    }
}

