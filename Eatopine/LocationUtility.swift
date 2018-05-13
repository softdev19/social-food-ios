//
//  LocationUtility.swift
//  Kisha
//
//  Created by Borna Beakovic on 14/09/14.
//  Copyright (c) 2014 Kisha. All rights reserved.
//

import UIKit
import MapKit

let LocationManager = LocationUtility.sharedInstance

class LocationUtility: NSObject, CLLocationManagerDelegate {
   
    var locManager: CLLocationManager?
    var userLocation:  CLLocation?
    
    typealias LocationUpdateCompletionClosure = (location: CLLocation?,error:NSError?) -> ()
    var completionHandler: LocationUpdateCompletionClosure!

    
    class var sharedInstance :LocationUtility {
    struct Singleton {
        static let instance = LocationUtility()
        }
        
        return Singleton.instance
    }
    
    func setupManager() {
        if self.locManager == nil {
            self.locManager = CLLocationManager()
            self.locManager?.delegate = self
            self.locManager?.desiredAccuracy = kCLLocationAccuracyBest
        }
    }
    
    func startUpdatingLocation() {
        self.locManager?.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        self.locManager?.stopUpdatingLocation()
        self.locManager = nil
    }
    
    func getCurrentUserLocation (completionClosure: (location: CLLocation?,error:NSError?) -> () ) {
        
        if CLLocationManager.locationServicesEnabled() == false {
            
            let error = NSError(domain: "LocationManagerAuthorizationError", code: 0, userInfo: [NSLocalizedDescriptionKey:"Location Services Disabled. Please enable them in device settings."])
            completionClosure(location: nil, error: error)
            return
        }
        
        self.completionHandler = completionClosure
        
        setupManager()
        
        if CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined {
            print("ask")
            self.locManager?.requestWhenInUseAuthorization()
            return
        }
    
        startUpdatingLocation()
    }
    

    //MARK: CLLocationManager delegate methods
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      
        if (locations.last == nil) {
          return
        }
      
        let lastLocation = locations.last
        let locationTimestamp = NSDate().timeIntervalSinceDate(lastLocation!.timestamp)
        
        
        if locationTimestamp < 60 && self.completionHandler != nil {
            self.userLocation = lastLocation
            LocationManager.setValue(lastLocation, forKeyPath: "userLocation")
            self.completionHandler(location:lastLocation, error: nil)
            self.completionHandler = nil
            stopUpdatingLocation()
        }
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print("error \(error)")
        
        if completionHandler != nil{
            completionHandler(location: nil, error: error)
            completionHandler = nil
        }
    }
    
    
    func reverseGeocode(userLocation:CLLocation,completionClosure: (placemark:CLPlacemark?,error: NSError?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: {(placemarks, error)->Void in
            userLocation.coordinate.longitude
            if (error != nil) {
                print("Reverse geocoder failed with error" + error!.localizedDescription)
                completionClosure(placemark: nil,error:error)
                return
            }
            
            if placemarks!.count > 0 {
                let pm = placemarks?.first
                completionClosure(placemark: pm,error:nil)
            } else {
                print("Problem with the data received from geocoder")
                completionClosure(placemark: nil,error:error)
            }
        })
    }
    /*
    func geocode(city:String, state:String,completionClosure: (message: String, latestLocation: CLLocation?) -> ()){
        
        
        CLGeocoder().geocodeAddressString("\(city),\(state)", completionHandler: { (placemarkArray:[AnyObject]!, error:NSError!) -> Void in
            if error == nil && placemarkArray.count > 0 {
                let placemark = placemarkArray[0] as! CLPlacemark
                
                completionClosure(message: "",latestLocation: placemark.location)
            }else if error == nil && placemarkArray.count == 0 {
                completionClosure(message: "We could not find la",latestLocation: nil)
            }else{
                completionClosure(message: "",latestLocation: nil)
            }
            
        })
        
    }
    */
    
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        print("new status  \(status.rawValue)")
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            print("status ")
            startUpdatingLocation()
        }
    }
}
