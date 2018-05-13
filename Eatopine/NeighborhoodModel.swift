//
//  NeighborhoodModel.swift
//  
//
//  Created by Borna Beakovic on 03/08/15.
//
//

import Foundation
import CoreData

class NeighborhoodModel: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var restaurants: NSSet

}
