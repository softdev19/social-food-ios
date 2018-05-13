//
//  EPFilter.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class EPFilter: NSObject {
   
    var price:[String]!
    var cuisine:[EPCuisine]!
    var dish:String!
    
    
    init(price:[String],cuisine:[EPCuisine], dish:String) {
        super.init()
        self.price = price
        self.dish = dish
        self.cuisine = cuisine
    }
    
    func getAllCuisines() -> String {
        
        var string = ""
        for (index,cuisine) in self.cuisine.enumerate()  {
            if index == 0{
                string += cuisine.name
            }else{
                string += ", \(cuisine.name)"
            }
            
        }
        
        if string.characters.count == 0 {
            return "none"
        }
        
        return string
    }
    func getDishName() -> String {
        if dish.characters.count == 0 {
            return "none"
        }
        return dish
    }
    
    func getDishNameParam() -> String {
        if dish.characters.count == 0 {
            return ""
        }
        return dish
    }
    
    func getAllCuisinesParam() -> String {
        
        var string = ""
        for (index,cuisine) in self.cuisine.enumerate()  {
            if index == 0{
                string += cuisine.name
            }else{
                string += ", \(cuisine.name)"
            }
        }
        
        if string.characters.count == 0 {
            return ""
        }
        
        return string
    }
    
    func getPricesParam() -> String {
        
        var string = ""
        for (index,pri) in self.price.enumerate()  {
            if index == 0{
                string += pri
            }else{
                string += ", \(pri)"
            }
        }
        
        if string.characters.count == 0 {
            return ""
        }
        
        return string
    }
}
