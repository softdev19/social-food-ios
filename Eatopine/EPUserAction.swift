//
//  EPUserAction.swift
//  Eatopine
//
//  Created by Borna Beakovic on 05/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON


class EPUserAction: Mappable {
   
    var name = ""
    var photo = ""
    var locality = ""
    var region = ""
    var restaurant_name = ""
    var review = ""
    var type:ActionType!
    
    var id: Int!
    var rating: Int!
    var createdDate: NSDate!
    
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
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
        
        
        let transformType = TransformOf<ActionType, String>(fromJSON: { (value: String?) -> ActionType? in
            
            return ActionType(rawValue: value!)
            }, toJSON: { (value: ActionType?) -> String? in
                // transform value from Int? to String?
                
                return nil
        })
        
        createdDate    <- (map["created"],CustomDateFormatTransform(formatString: "YYYY-MM-dd HH:mm:ss"))
        name    <- map["name"]
        photo    <- map["photo"]
        locality    <- map["locality"]
        region    <- map["region"]
        restaurant_name    <- map["restaurant_name"]
        review    <- map["review"]
        id    <- (map["id"],transformInt)
        rating    <- (map["rating"],transformInt)
        type    <- (map["type"],transformType)
    }
}
