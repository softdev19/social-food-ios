//
//  EPUser.swift
//  Eatopine
//
//  Created by Borna Beakovic on 05/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPUser: Mappable {
   
    var username = ""
    var display_name = ""
    var email = ""
    var firstname = ""
    var lastname = ""
    var city = ""
    var profilePhoto = ""
    
    var id: Int!
    var points: Int!
    var rest_reviews: Int!
    var dish_reviews: Int!
    var checkin: Int!
    
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
        display_name  <- map["display_name"]
        profilePhoto    <- map["profile_picture"]
        email    <- map["email"]
        firstname    <- map["firstname"]
        city    <- map["city"]
        lastname    <- map["lastname"]
        id    <- (map["id"],transformInt)
        points    <- (map["points"],transformInt)
        rest_reviews    <- (map["rest_reviews"],transformInt)
        dish_reviews    <- (map["dish_reviews"],transformInt)
        checkin    <- (map["checkin"],transformInt)
    }
}

class UserProfile: Mappable {
    var login_id = 0
    var username = ""
    var fullname = ""
    var email = ""
    var phone = ""
    var gender = ""
    var city = ""
    var profilePhoto = ""
    var description = ""
    var rank = ""
    var followers = 0
    var following = 0
    var photos = 0
    
    required init?(_ map: Map){
        
    }
    
    // Mappable
    func mapping(_ map: Map) {
        
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
        
        login_id    <- (map["login_id"], transformInt)
        username    <- map["username"]
        fullname    <- map["fullname"]
        email       <- map["email"]
        phone       <- map["phone"]
        city        <- map["city"]
        gender      <- map["gender"]
        profilePhoto    <- map["profile_picture"]
        description <- map["description"]
        rank        <- map["rank"]
        followers   <- (map["followers"], transformInt)
        following   <- (map["following"], transformInt)
        photos      <- (map["photos"], transformInt)
    }
}
