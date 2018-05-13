//
//  EPActivity.swift
//  Eatopine
//
//  Created by  on 10/7/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

enum ActionType : String {
    case RatingLike = "dish_rating_like"
    case RatingComment = "dish_rating_comment"
    //case DishReview = ""
}

class EPActivity: Mappable {
    var ratingId = 0
    var review = ""
    var comments = 0
    var likes = 0
    var dishName = ""
    var photo = ""
    var userName = ""
    var userId = 0
    var created: NSDate!
    var type: ActionType!
    var description = ""
    
    required init?(_ map: Map){
        
    }
    
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
        
        created    <- (map["created"],CustomDateFormatTransform(formatString: "YYYY-MM-dd HH:mm:ss"))
        userName   <- map["username"]
        photo    <- map["photo"]
        ratingId    <- map["rating_id"]
        review    <- map["review"]
        comments    <- (map["comments"], transformInt)
        likes    <- (map["likes"], transformInt)
        dishName    <- map["dish_name"]
        userId    <- (map["user_id"],transformInt)
        description  <- map["description_text"]
        type    <- (map["type"],transformType)
    }

}