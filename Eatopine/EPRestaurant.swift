//
//  EPRestaurant.swift
//  Eatopine
//
//  Created by Borna Beakovic on 09/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

class EPRestaurant: Mappable {

    var name = ""
    var region = ""
    var locality = ""
    var photo = ""
    var address = ""
    var dish_name = ""
    var dish_id: Int!
    var rating:Float = 0.0
    var latitude:Float = 0.0
    var longitude:Float = 0.0
    var id: Int!
    var number_ratings: Int = 0
    var number_dishes: Int = 0
    var number_of_photos: Int = 0
    var number_of_dish_reviews: Int = 0
    var price:Int = 0
    var distance: Float = 0.0
    
    var tel = ""
    var fax = ""
    var website = ""
    var email = ""
    
    var best_dish_id:Int = 0
    var best_dish_name = ""
    var best_dish_photo = ""
    
    var hours: [AnyObject]?
    
    var cuisine:[String]?
    
    var fullAddress:String {
        get {
            return "\(address), \(locality), \(region)"
        }
    }
    
    
    required init?(_ map: Map){
        
    }

    
    // Mappable
    func mapping(map: Map) {
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
        let transformFloat = TransformOf<Float, String>(fromJSON: { (value: String?) -> Float? in
            // transform value from String? to Float?
            if value?.floatValue != nil {
                return value?.floatValue
            }else{
                return 0
            }
            
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
        
        /*
        let transformCuisine = TransformOf<[String], String>(fromJSON: { (value: String?) -> [String]? in
            // transform value from String? to Int?
            
            /*
            let json = JSON(value!)
            println("transform \(json)")
            
            
            let array:NSArray = NSArray(objects: json.string!)
            
            println("arr \(array)")
            
         //   println("aaa \(string)")
            var arrayCuisine = json.rawValue as! [String]
            for (index: String, subJson: JSON) in json {
                //Do something you want
                println("sub \(subJson)")
                arrayCuisine.append(subJson.string!)
            }
    //        for cuisine in array as [] {
      //          arrayCuisine.append(cuisine as! String)
        //    }
            */
            return [String]()
            
            }, toJSON: { (value: [String]?) -> String? in
                // transform value from Int? to String?
                if let value = value {
                    return String(stringInterpolationSegment: value)
                }
                return nil
        })
        */
        name    <- map["name"]
        rating    <- (map["rating"], transformFloat)
        latitude    <- (map["latitude"], transformFloat)
        longitude    <- (map["longitude"], transformFloat)
        id    <- (map["id"],transformInt)
        number_ratings    <- (map["number_ratings"],transformInt)
        number_dishes    <- (map["number_of_dishes"],transformInt)
        number_of_dish_reviews    <- (map["number_of_dish_reviews"],transformInt)
        number_of_photos    <- (map["number_of_photos"],transformInt)
        price    <- (map["price"],transformInt)
        region    <- map["region"]
        locality    <- map["locality"]
        photo    <- map["photo"]
        if photo.characters.count == 0 {
            photo <- map["restaurant_photo"]
        }
        address    <- map["address"]
        dish_name    <- map["dish_name"]
        dish_id    <- (map["dish_id"],transformInt)
        cuisine   <- map["cuisine"]
        
        hours    <- map["hours"]
        tel    <- map["tel"]
        fax    <- map["fax"]
        website    <- map["website"]
        email    <- map["email"]
        
        best_dish_name    <- map["best_dish_name"]
        best_dish_photo    <- map["best_dish_photo"]
        best_dish_id    <- (map["best_dish_id"],transformInt)
        distance    <- (map["distance"], transformFloat)
    }
    
    
    
    func getPriceString() -> String {
        var string = ""
        for (var i = 0; i < price; i++){
            string = string + "$"
        }
        
        return string
    }
    
}
