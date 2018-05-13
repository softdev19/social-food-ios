//
//  MapDirectionsViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import MapKit

class MapDirectionsViewController: UIViewController,MKMapViewDelegate,UIActionSheetDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    var restaurant:EPRestaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restaurant.name
    }

    @IBAction func popController(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func showDirectionOptions(sender: AnyObject?) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeButton = UIAlertAction(title: "Google Maps", style: UIAlertActionStyle.Default, handler: { (takeButton:UIAlertAction) -> Void in
            let address = self.restaurant.fullAddress.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        //    let address = restaurant.fullAddress.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)
            let url:String? = "comgooglemaps://?daddr=\(address!)&directionsmode=driving"
            print("address \(address)")
            print("url \(url)")
            if url != nil {
                UIApplication.sharedApplication().openURL(NSURL(string: url!)!)
            }
        })
        alertController.addAction(takeButton)
        let chooseButton = UIAlertAction(title: "Apple Maps", style: UIAlertActionStyle.Default, handler: { (chooseButton:UIAlertAction) -> Void in
            let place = MKPlacemark(coordinate: CLLocationCoordinate2DMake(CLLocationDegrees(self.restaurant.latitude) ,CLLocationDegrees(self.restaurant.longitude)), addressDictionary: nil)
            let destination = MKMapItem(placemark: place)
            destination.name = self.restaurant.name
            let options = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving]
            MKMapItem.openMapsWithItems([destination], launchOptions: options)
        })
        alertController.addAction(chooseButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    

    //MARK: MKMapView methods
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        
        if annotation.title! == "UserLocation" {
            annotationView!.canShowCallout = false
            annotationView!.image = UIImage(named: "")
        }else{
            annotationView!.canShowCallout = true
            annotationView!.image = UIImage(named: "pinRestaurant")
            annotationView!.centerOffset = CGPointMake(0, -annotationView!.image!.size.height / 2);
        }
        
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
        let location = CLLocation(latitude: CLLocationDegrees(restaurant.latitude) , longitude: CLLocationDegrees(restaurant.longitude))
        let annotation = RestaurantPointAnnotation(restaurant: restaurant, coordinate: location.coordinate)
        annotation.title = restaurant.name
        let userAnnotation = MKPointAnnotation()
        userAnnotation.title = "UserLocation"
        userAnnotation.coordinate = userLocation.coordinate
        self.mapView.showAnnotations([annotation], animated: false)
       // self.mapView.showAnnotations([annotation,userAnnotation], animated: false)
    }
}
