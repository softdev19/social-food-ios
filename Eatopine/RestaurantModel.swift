//
//  RestaurantModel.swift
//  
//
//  Created by Borna Beakovic on 03/08/15.
//
//

import Foundation
import CoreData

class RestaurantModel: NSManagedObject {

    @NSManaged var id: NSNumber
    @NSManaged var name: String
    @NSManaged var address: String
    @NSManaged var locality: String
    @NSManaged var region: String
    @NSManaged var latitude: NSNumber
    @NSManaged var longitude: NSNumber
    @NSManaged var price: NSNumber
    @NSManaged var rating: NSNumber
    @NSManaged var number_ratings: NSNumber
    @NSManaged var photo: String
    @NSManaged var dish_name: String
    @NSManaged var dish_id: NSNumber
    @NSManaged var distance: NSNumber
    @NSManaged var cuisine: NSSet
    @NSManaged var neighborhood: NSSet

}
