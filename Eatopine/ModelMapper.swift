//
//  Mapper.swift
//  Eatopine
//
//  Created by Borna Beakovic on 09/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper

class ModelMapper: NSObject {

    class func mapRestaurantsJSON(response:AnyObject) -> [EPRestaurant]?{
        
         let array = Mapper<EPRestaurant>().mapArray(response)
        return array
    }
    
    class func mapRestaurantInfoJSON(response:AnyObject) -> EPRestaurantInfo{
        return Mapper<EPRestaurantInfo>().map(response)!
    }
    
    class func mapSingledRestaurantJSON(response:AnyObject) -> EPRestaurant{
        return Mapper<EPRestaurant>().map(response)!
    }
    
    class func mapSingledDishJSON(response:AnyObject) -> EPDish{
        return Mapper<EPDish>().map(response)!
    }
    
    class func mapSingleMapDishJSON(response:AnyObject) -> EPMapDish {
        return Mapper<EPMapDish>().map(response)!
    }
    
    class func mapDishesJSON(response:AnyObject) -> [EPDish]?{
        let array = Mapper<EPDish>().mapArray(response)
        return array
    }
    
    class func mapSearchDishesJSON(response: AnyObject) -> [EPSearchDish]? {
        let array = Mapper<EPSearchDish>().mapArray(response)
        return array
    }
    
    class func mapResDishesJSON(response:AnyObject) -> [EPResDish]? {
        let array = Mapper<EPResDish>().mapArray(response)
        return array
    }
    
    class func mapSearchDishesJSON(response:AnyObject) -> [EPMapDish]? {
        let array = Mapper<EPMapDish>().mapArray(response)
        return array
    }
    
    class func mapCuisineJSON(response:AnyObject) -> [EPCuisine]{
        return Mapper<EPCuisine>().mapArray(response)!
    }
    
    class func mapUsersJSON(response:AnyObject) -> [LikeUser]{
        return Mapper<LikeUser>().mapArray(response)!
    }
}
