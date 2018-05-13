//
//  Comment.swift
//  Eatopine
//
//  Created by Eden on 9/18/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class Comment: Mappable {
    
    var comment_id: Int = 0
    var rating_id: Int = 0
    var login_id: Int = 0
    var username: String = ""
    var profile_picture: String = ""
    var comment: String = ""
    var text: String = ""
    var created: String = ""
    
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
        
        comment_id    <- (map["comment_id"], transformInt)
        rating_id    <- (map["rating_id"], transformInt)
        login_id    <- (map["login_id"], transformInt)
        username    <- map["username"]
        profile_picture    <- map["profile_picture"]
        comment    <- map["comment"]
        created    <- map["created"]
        text <- map["text"]
    }
}