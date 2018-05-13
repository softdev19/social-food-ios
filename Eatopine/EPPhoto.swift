//
//  EPPhoto.swift
//  Eatopine
//
//  Created by Borna Beakovic on 30/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPPhoto: Mappable {
   
    var author_display_name = ""
    var url = ""
    var description = ""
    var id: Int?
    var dish_id: Int?
    var author_points: Int!
    var createdDate: NSDate!
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
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
        
        createdDate    <- (map["created"],CustomDateFormatTransform(formatString: "YYYY-MM-dd HH:mm:ss"))
        author_display_name    <- map["author_display_name"]
        url    <- map["photo"]
        description    <- map["description"]
        author_points    <- (map["author_points"],transformInt)
        dish_id    <- (map["dish_id"],transformInt)
        id    <- (map["id"],transformInt)
    }
}
