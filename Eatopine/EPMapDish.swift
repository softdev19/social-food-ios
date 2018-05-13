//
//  EPMapDish.swift
//  Eatopine
//
//  Created by  on 10/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPMapDish: Mappable {
    var number_ratings = 0
    var restaurantName = ""
    var vote: Float = 0
    var dishName = ""
    var restaurant_id = 0
    var number_likes = 0
    var reviews = [Review]()
    
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
        number_ratings  <- (map["number_ratings"], transformInt)
        number_likes  <- (map["number_likes"], transformInt)
        reviews   <- map["reviews"]
    }
}
