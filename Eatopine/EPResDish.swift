//
//  EPResDish.swift
//  Eatopine
////  Created by  on 10/19/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPResDish: Mappable {
    var id = 0
    var locu_id = 0
    var name = ""
    var description = ""
    var course_id = 0
    var menuType = ""
    var price:Float = 0
    var added_by_id = 0
    var created = ""
    var status = 0
    var rest_id = 0
    var type_id = 0
    var vote :Float = 0
    var number_rating = 0
    var section = ""
    var subsection = ""
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
        
        id  <- (map["id"], transformInt)
        locu_id     <- (map["locu_id"], transformInt)
        name    <- map["name"]
        description <- map["description"]
        course_id   <- (map["course_id"], transformInt)
        menuType    <- map["menu_type"]
        price       <- (map["price"], transformFloat)
        added_by_id  <- (map["added_by_id"], transformInt)
        created     <- map["created"]
        status      <- (map["status"], transformInt)
        rest_id     <- (map["restaurant_id"], transformInt)
        type_id     <- (map["type_id"], transformInt)
        vote        <- (map["vote"], transformFloat)
        number_rating   <- (map["number_ratings"], transformInt)
        section     <- map["section"]
        subsection  <- map["subsection"]
        photo       <- map["photo"]
    }
}
