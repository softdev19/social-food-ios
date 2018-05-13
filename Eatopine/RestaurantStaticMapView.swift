//
//  RestaurantDetailMapView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import MapKit

protocol RestaurantStaticMapViewDelegate {
    func showDirections()
}


class RestaurantStaticMapView: UIView,MKMapViewDelegate {

    private var view: UIView!
    var delegate: RestaurantStaticMapViewDelegate?
    @IBOutlet weak private var lblAddress: UILabel!
    @IBOutlet weak private var mapView: SMMapView!
    
    var restaurant: EPRestaurant!
    
    
    init(restaurant:EPRestaurant,frame:CGRect, delegate:RestaurantStaticMapViewDelegate) {
        
        super.init(frame: frame)
        xibSetup()
        self.restaurant = restaurant
        self.delegate = delegate
        lblAddress.text = restaurant.fullAddress
        
        mapView.userLocation.title = MAP_USER_LOCATION_TITLE
        mapView.calloutView = SMCalloutView.platformCalloutView()
        mapView.delegate = self
        
        
        let location = CLLocation(latitude: CLLocationDegrees(restaurant.latitude) , longitude: CLLocationDegrees(restaurant.longitude))
        let annotation = RestaurantPointAnnotation(restaurant: restaurant, coordinate: location.coordinate)
        self.mapView.addAnnotation(annotation)
        
        let zoomLocationOffset = CLLocation(latitude: CLLocationDegrees(restaurant.latitude + 0.001) , longitude: CLLocationDegrees(restaurant.longitude))
        
        let region = MKCoordinateRegionMakeWithDistance(zoomLocationOffset.coordinate, 300, 300)
        self.mapView.setRegion(region, animated: false)
    
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "RestaurantStaticMapView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView!.canShowCallout = false
        annotationView!.image = UIImage(named: "pinRestaurant")
        annotationView!.centerOffset = CGPointMake(0, -annotationView!.image!.size.height / 2);
        
        self.mapView(mapView, didSelectAnnotationView: annotationView!)
        
        return annotationView
    }
    
    
    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {
      //  let annotation = annotationView.annotation as! RestaurantPointAnnotation
        
        let callout = StaticMapCalloutView.instanceFromNib()
        callout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(RestaurantStaticMapView.addressClicked(_:))))
        callout.lblName.text = restaurant.name

        self.mapView.calloutView?.contentViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.mapView.calloutView!.contentView = callout
     //   self.mapView.calloutView?.backgroundView.arrowPoint = CGPointMake(-100, -100)
        self.mapView.calloutView!.presentCalloutFromRect(annotationView.bounds, inView: annotationView, constrainedToView: self.view, animated: false)
    }
    
    @IBAction func addressClicked(sender: AnyObject?) {
        
        delegate?.showDirections()
    }
    
}
