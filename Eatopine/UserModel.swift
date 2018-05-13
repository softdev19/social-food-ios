//
//  UserModel.swift
//  
//
//  Created by Borna Beakovic on 27/07/15.
//
//

import Foundation
import CoreData

class UserModel: NSManagedObject {

    @NSManaged var email: String
    @NSManaged var firstname: String
    @NSManaged var lastname: String
    @NSManaged var display_name: String
    @NSManaged var id: NSNumber

}
