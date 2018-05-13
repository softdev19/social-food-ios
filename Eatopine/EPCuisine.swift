//
//  EPCuisine.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import ObjectMapper

class EPCuisine: NSObject, NSCoding, Mappable {
   
    
    var name = ""
    var id: Int!
    
    
    required init?(_ map: Map){
        
    }
    
    override init() {
        super.init()
    }
    
    // Mappable
    func mapping(map: Map) {
        
        let nf = NSNumberFormatter()
        nf.numberStyle = .DecimalStyle
        
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

    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.name, forKey: "Name")
        aCoder.encodeObject(self.id, forKey: "Id")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.name = aDecoder.decodeObjectForKey("Name") as! String
        self.id = aDecoder.decodeObjectForKey("Id") as! Int
    }
    
}

func ==(lhs: EPCuisine, rhs: EPCuisine) -> Bool {
    return lhs.id == rhs.id //replace with code for your struct.
}
