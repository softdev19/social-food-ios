//
//  Constants.swift
//  Eatopine
//
//  Created by Borna Beakovic on 26/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import Foundation


let UserDefaults = NSUserDefaults.standardUserDefaults() as NSUserDefaults
let NotificationCenter = NSNotificationCenter.defaultCenter() as NSNotificationCenter
let ApplicationDelegate = UIApplication.sharedApplication().delegate as! AppDelegate


let COLOR_EATOPINE_RED = UIColor(red: 235/255.0, green: 84/255.0, blue: 84/255.0, alpha: 1.0)
let COLOR_EATOPINE_REAL_RED = UIColor(red: 243/255.0, green: 51/255.0, blue: 46/255.0, alpha: 1.0)
let COLOR_EATOPINE_BLUE = UIColor(red: 40/255, green: 95/255, blue: 163/255, alpha: 1.0)
let COLOR_EATOPINE_GRAY = UIColor(red: 211/255, green: 211/255, blue: 211/255, alpha: 1.0)

let BaseURL = "https://app.eatopine.com/v3"
let WEB_LINK_TOS = "http://www.eatopine.com/p/terms-of-service"
let WEB_LINK_PRIVACY_POLICY = "http://www.eatopine.com/p/privacy-policy"

let MAP_USER_LOCATION_TITLE = "Your location"
let DOWNLOAD_OBJECT_LIMIT = 20
let LIST_NEEDS_REFRESH = "ListNeedsRefresh"