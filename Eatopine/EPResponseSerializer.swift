//
//  EPResponseSerializer.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import AFNetworking
import SwiftyJSON

let EPErrorResponseKey = "EPErrorResponseKey"

class EPResponseSerializer: AFJSONResponseSerializer {
   

    override func responseObjectForResponse(response: NSURLResponse!, data: NSData!) throws -> AnyObject {
        do {
            try self.validateResponse(response as? NSHTTPURLResponse, data: data)
        }catch var error as NSError{
            
            var userInfo = error.userInfo
            do{
                let json = try NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions())
                print("json \(json)")
                if let dict = json as? NSDictionary {
                    if dict.objectForKey("error") != nil {
                        let error = dict.objectForKey("error")
                        print("errrr \(error)")
                        if let errorDict = error as? NSDictionary {
                            if errorDict.objectForKey("description") != nil && errorDict.objectForKey("message") != nil{
                                
                                let desc = errorDict.objectForKey("description") as! String
                                let message = errorDict.objectForKey("message") as! String
                                
                                let epError = EPError(message: message, description: desc)
                                userInfo[EPErrorResponseKey] = epError
                            }
                        }
                    }
                }
                
                error = NSError(domain: error.domain, code: error.code, userInfo: userInfo)
                throw error
            } catch  let error as NSError{
                print(error)
                throw error
            }
            
        }
        
        return try super.responseObjectForResponse(response, data: data)
    }
    
}
