//
//  EPReview.swift
//  Eatopine
//
//  Created by Borna Beakovic on 30/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPReview: Mappable {
    
    var id: Int!
    var login_id: Int!
    var dish_id: Int!
    var rating: Int!
    var author_points: Int!
    
    var review = ""
    var author_display_name = ""
    var author_profilePhoto = ""
    var author_id: Int!
    var createdDate: NSDate!
    
    var status: Bool!
    var confirmed: Bool!
    var first: Bool!
    
    var photos:[EPPhoto]?
    var dish_name = ""
    var restaurant_name = ""
    
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
        
        
        login_id    <- (map["login_id"],transformInt)
        id    <- (map["id"],transformInt)
        author_points <- (map["points"],transformInt)
        author_profilePhoto    <- map["profile_picture"]
        dish_id    <- (map["dish_id"],transformInt)
        rating    <- (map["rating"],transformInt)
        author_id    <- (map["login_id"],transformInt)
        review    <- map["review"]
        createdDate    <- (map["created"],CustomDateFormatTransform(formatString: "YYYY-MM-dd HH:mm:ss"))
        status    <- map["status"]
        confirmed    <- map["confirmed"]
        author_display_name    <- map["display_name"]
        
        photos    <- (map["photo"])
        dish_name    <- map["dish_name"]
        restaurant_name    <- map["restaurant_name"]
    }
}
