//
//  EPError.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class EPError {
   
    var errorDescription:String
    var errorMessage:String
    
    init(message:String,description:String) {
        self.errorDescription = description
        self.errorMessage = message
    }
}
