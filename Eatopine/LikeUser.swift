//
//  LikeUserMode.swift
//  Eatopine
//
//  Created by Tony on 9/22/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class LikeUser: Mappable {
    
    var username = ""
    var fullname = ""
    var profilePhoto = ""
    var loged_id = 0
    
    var followed = 0
    var photos = 0
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(map: Map) {
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        /*
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
         */
        
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
        
        username    <- map["username"]
        fullname <- map["fullname"]
        profilePhoto    <- map["profile_picture"]
        loged_id    <- (map["login_id"],transformInt)
        photos         <- (map["photos"],transformInt)
        followed    <- (map["followed"],transformInt)
        
    }
}

