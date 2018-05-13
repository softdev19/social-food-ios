//
//  EPDish.swift
//  Eatopine
//
//  Created by Borna Beakovic on 10/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPDish: Mappable {
   
    var name = ""
    var photos:[EPPhoto]?

    var address = ""
    var locality = ""
    var region = ""
    
    var author_id: Int!
    var rating:Float = 0.0
    var latitude:Float = 0
    var longitude:Float = 0
    var id: Int!
    var restaurant_id: Int!
    var number_ratings: Int!
    var price:Float = 0
    
    var rating_id: Int!
    var login_id: Int!
    var profile_picture = ""
    var username = ""
    var restaurant_name = ""
    var vote = 0
    var created = ""
    var n_likes = 0
    var n_comments = 0
    var photo = ""
    var dish_name = ""
    var rating_text = ""
    var liked = 0
    var comments:[Comment] = []
    
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

        name    <- map["name"]
        id    <- (map["id"],transformInt)
        restaurant_id    <- (map["restaurant_id"],transformInt)
        number_ratings    <- (map["number_ratings"],transformInt)
        address    <- map["address"]
        // cuisine
        locality    <- map["locality"]
        region    <- map["region"]
        latitude    <- (map["latitude"], transformFloat)
        longitude    <- (map["longitude"], transformFloat)
        price    <- (map["price"],transformFloat)
        rating    <- (map["rating"], transformFloat)
        photo    <- map["photo"]
        photos    <- (map["photo"])
        author_id    <- (map["login_id"],transformInt)
        if author_id == nil || author_id == 0 {
            author_id    <- (map["added_by_id"],transformInt)
        }
        
        rating_id   <- (map["rating_id"], transformInt)
        login_id    <- (map["login_id"], transformInt)
        profile_picture     <- map["profile_picture"]
        username    <- map["username"]
        restaurant_name     <- map["restaurant_name"]
        vote    <- (map["vote"], transformInt)
        created     <- map["created"]
        n_likes     <- (map["n_likes"], transformInt)
        n_comments  <- (map["n_comments"], transformInt)
        dish_name   <- map["dish_name"]
        rating_text <- map["rating_text"]
        comments <- map["comments"]
        liked  <- (map["liked"], transformInt)
    }
    
    
    func convertStringToDictionary(text: String) -> [[String:AnyObject]]? {
        if let data = text.dataUsingEncoding(NSUTF8StringEncoding) {
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions()) as? [[String:AnyObject]]
                return json
            } catch  let error as NSError{
                print(error)
            }
        }
        return nil
    }
}
