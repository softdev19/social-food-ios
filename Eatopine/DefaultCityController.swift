//
//  DefaultCityController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 03/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import Foundation

let USER_DEFAULTS_CITYNAME = "CityName"
let USER_DEFAULTS_STATE = "State"
let USER_DEFAULTS_LONGITUDE = "Longitude"
let USER_DEFAULTS_LATITUDE = "Latitude"

class DefaultCityController {
    
    
    class func getDefault() -> CityDetails {
        
        if let cityName = UserDefaults.objectForKey(USER_DEFAULTS_CITYNAME) as? String{
            
            let state = UserDefaults.objectForKey(USER_DEFAULTS_STATE) as! String
            let longitude = UserDefaults.floatForKey(USER_DEFAULTS_LONGITUDE)
            let latitude = UserDefaults.floatForKey(USER_DEFAULTS_LATITUDE)
            
            return CityDetails(name: cityName, state: state, lat: latitude, lng: longitude)
        }else{
            // set New York as default
            print("Setting Default City")
            
            let cityName = "New York"
            let state = "NY"
            let latitude:Float = 40.763426
            let longitude:Float = -73.980705
            
            setDefaultCity(cityName, state: state, lat: latitude, lng: longitude)
            return CityDetails(name: cityName, state: state, lat: latitude, lng: longitude)
        }
    }
    
    class func setDefaultCity(city: CityDetails) {
        setDefaultCity(city.name, state: city.state, lat: city.latitude, lng: city.longitude)
    }
    
    class func setDefaultCity(name: String, state: String, lat:Float, lng: Float) {
        
        UserDefaults.setObject(name, forKey: USER_DEFAULTS_CITYNAME)
        UserDefaults.setObject(state, forKey: USER_DEFAULTS_STATE)
        UserDefaults.setFloat(lat, forKey: USER_DEFAULTS_LATITUDE)
        UserDefaults.setFloat(lng, forKey: USER_DEFAULTS_LONGITUDE)
        UserDefaults.synchronize()
    }
    
}