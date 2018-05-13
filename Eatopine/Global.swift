
//
//  Global.swift
//  Eatopine
//
//  Created by Eden on 9/12/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import Foundation

class Global {
    
    static func createJoinedCuisines(cuisines: [String]) -> String? {
        var joinedCuisines = ""
        let separateCuisines = cuisines
        for i in 0 ..< separateCuisines.count {
            joinedCuisines += separateCuisines[i]
            if i < cuisines.count - 1 {
                joinedCuisines += " , "
            }
        }
        return joinedCuisines
    }
}
