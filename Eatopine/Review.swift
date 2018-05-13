//
//  Review.swift
//  Eatopine
//
//  Created by  on 10/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class Review: Mappable {
    
    var rating_id: Int = 0
    var login_id: Int = 0
    var username: String = ""
    var profile_picture: String = ""
    var text: String = ""
    var created: String = ""
    var vote: Float = 0
    var rank = ""
    var photo = ""
    
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
        
        rating_id    <- (map["rating_id"], transformInt)
        login_id    <- (map["login_id"], transformInt)
        username    <- map["author_username"]
        profile_picture    <- map["profile_picture"]
        created    <- map["created"]
        text <- map["text"]
        rank <- map["author_rank"]
        photo  <- map["photo"]
        vote  <- (map["vote"], transformFloat)
    }

}
