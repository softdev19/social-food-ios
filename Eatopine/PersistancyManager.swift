//
//  PersistancyManager.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import MagicalRecord
import SwiftyJSON

class PersistancyManager: NSObject {
   
    
    func saveUser(responseObject:AnyObject, completionClosure: ((success: Bool) -> () )) {
        
        MagicalRecord.saveWithBlock { (context:NSManagedObjectContext!) -> Void in
            let json = JSON(responseObject)
            
            let userId = json["id"].intValue
            var user = UserModel.MR_findFirstByAttribute("id", withValue: userId)
            
            if user == nil{
                user = UserModel.MR_createEntityInContext(context)
                print("creating user")
            }else{
                print("updating user")
            }
            user.MR_importValuesForKeysWithObject(responseObject)
            let delay = 0.2 * Double(NSEC_PER_SEC)
            let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
            dispatch_after(delayTime, dispatch_get_main_queue(), {
                completionClosure(success: true)
            })
        }
    }
    
    /*
    func saveRestaurants(responseObject:AnyObject, completionClosure: ((restaurants:[RestaurantModel]) -> ())) {
        
        MagicalRecord.saveWithBlock { (context:NSManagedObjectContext!) -> Void in
            let json = JSON(responseObject)
            
            var objects = [RestaurantModel]()
            
            for object in json.array! {
                let restaurantId = object["id"].intValue
                var restaurant = RestaurantModel.MR_findFirstByAttribute("id", withValue: restaurantId)
                
                if restaurant == nil{
                    restaurant = RestaurantModel.MR_createEntityInContext(context)
                    println("creating restaurant")
                }else{
                    println("updating restaurant")
                }
                
                objects.append(restaurant)
            }
            
            completionClosure(restaurants: objects)
        }
        
    }
    
    class func getRestaurantById(restaurantId:Int) -> RestaurantModel?{
        return RestaurantModel.MR_findFirstByAttribute("id", withValue: restaurantId)
    }
    */
    class func getCurrentUser() -> UserModel?{
        return UserModel.MR_findFirst()
    }
    
    class func saveFilter(filter:EPFilter) {
        
        UserDefaults.setObject(filter.price, forKey: "FilterPrice")
        
        let cuisineData = NSKeyedArchiver.archivedDataWithRootObject(filter.cuisine)
        UserDefaults.setObject(cuisineData, forKey: "FilterCuisine")
        UserDefaults.setObject(filter.dish, forKey: "FilterDish")
        UserDefaults.synchronize()
    }
    
    class func getFilter() -> EPFilter {
        
        var price = UserDefaults.objectForKey("FilterPrice") as? [String]
        let cuisineData = UserDefaults.objectForKey("FilterCuisine") as? NSData
        var dish = UserDefaults.objectForKey("FilterDish") as? String
        
        var cuisine:[EPCuisine]!
        
        if price == nil {
            price = [String]()
        }
        if cuisineData == nil {
            cuisine = [EPCuisine]()
        }else{
            cuisine = NSKeyedUnarchiver.unarchiveObjectWithData(cuisineData!) as! [EPCuisine]
        }
        if dish == nil {
            dish = ""
        }
        
        return EPFilter(price: price!, cuisine: cuisine!, dish: dish!)
    }
    
    class func isFacebookSharingActive() -> Bool {
        if UserDefaults.objectForKey("FacebookSharing") != nil{
            return UserDefaults.boolForKey("FacebookSharing")
        }else{
            return false
        }
    }
    
    class func setFacebookSharing(activeState:Bool) {
        UserDefaults.setBool(activeState, forKey: "FacebookSharing")
        UserDefaults.synchronize()
    }
    
    class func isTwitterSharingActive() -> Bool {
        if UserDefaults.objectForKey("TwitterSharing") != nil{
            return UserDefaults.boolForKey("TwitterSharing")
        }else{
            return false
        }
    }
    
    class func setTwitterSharing(activeState:Bool) {
        UserDefaults.setBool(activeState, forKey: "TwitterSharing")
        UserDefaults.synchronize()
    }
}
