//
//  MapViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, SMCalloutViewDelegate, UITableViewDelegate, UISearchBarDelegate,UISearchControllerDelegate {

    private enum SearchType: String {
        case Restaurant = "restaurant"
        case Dish = "dish"
    }
    
    @IBOutlet weak var viewSearchBar: UIView!
    var searchResults = [EPRestaurant]()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var mapView: SMMapView!
    var restaurantsArray = [EPRestaurant]()
    
    @IBOutlet weak var segmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var segmentView: UIView!
    var btnSearch: UIBarButtonItem!
    
    private var currentSearchType = SearchType.Restaurant
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = nil
        self.segmentHeightConstraint.constant = 0
        self.segmentView.hidden = true
        
        btnSearch = UIBarButtonItem(title: "search", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(onSearchClick(_:)))
        btnSearch.tintColor = UIColor.whiteColor()
        
        mapView.userLocation.title = MAP_USER_LOCATION_TITLE
        mapView.calloutView = SMCalloutView.platformCalloutView()
        mapView.calloutView!.delegate = self
        
        self.searchBar.delegate = self
        
        nearbyPressed(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onValueChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            currentSearchType = .Restaurant
        }
        else {
            currentSearchType = .Dish
        }
    }
    
    @IBAction func onSearchClick(sender: UIBarButtonItem) {
        self.navigationItem.rightBarButtonItem = nil
        self.segmentHeightConstraint.constant = 0
        self.segmentView.hidden = true
        
        LocationManager.getCurrentUserLocation { (location, error) in
            if error == nil {
                EatopineAPI.downloadRestaurantByString(self.searchBar.text!, userLocation: location!, searchType: self.currentSearchType.rawValue, completionClosure: { (success, restaurants) in
                    AppUtility.hideActivityOverlay()
                    if restaurants == nil {
                        self.restaurantsArray = [EPRestaurant]()
                    }
                    else {
                        self.restaurantsArray = restaurants!
                    }
                    self.addNearbyRestaurantsToMap()
                })
            }
            else {
                AppUtility.hideActivityOverlay()
                AppUtility.showAlert(error!.localizedDescription, title: "Location error")
            }
        }
    }
    
    func addNearbyRestaurantsToMap() {
        self.mapView.removeAnnotations(mapView.annotations)
        
        for restaurant in self.restaurantsArray {
            let location = CLLocation(latitude: CLLocationDegrees(restaurant.latitude) , longitude: CLLocationDegrees(restaurant.longitude))
            
            let annotation = RestaurantPointAnnotation(restaurant: restaurant, coordinate: location.coordinate)
            self.mapView.addAnnotation(annotation)
        }
        
        self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: false)
    }
    
    //MARK: Actions
    
    @IBAction func nearbyPressed(sender: AnyObject?) {
    //    AppUtility.showActivityOverlay("Locating nearby")
        LocationManager.getCurrentUserLocation { (location, error) -> () in
            if error == nil {
                let filter = PersistancyManager.getFilter()
                
                EatopineAPI.downloadRestaurantByString("", userLocation: location!, searchType: self.currentSearchType.rawValue, completionClosure: { (success, restaurants) in
                    AppUtility.hideActivityOverlay()
                    if restaurants == nil {
                        self.restaurantsArray = [EPRestaurant]()
                    }
                    else {
                        self.restaurantsArray = restaurants!
                    }
                    self.addNearbyRestaurantsToMap()
                })
            }else{
                AppUtility.hideActivityOverlay()
                AppUtility.showAlert(error!.localizedDescription, title: "Location error")
            }
        }
    }
    
    
    @IBAction func openFilters(sender: AnyObject?) {
        
        let filtersViewController = storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController") as! FiltersViewController
        let navController = RedNavigationController(rootViewController: filtersViewController)
        self.presentViewController(navController, animated: true, completion: nil)
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
        annotationView!.canShowCallout = false
        annotationView!.image = UIImage(named: "pinRestaurant")
        annotationView!.centerOffset = CGPointMake(0, -annotationView!.image!.size.height / 2);
        
        return annotationView
    }
    
    func mapView(mapView: MKMapView, didSelectAnnotationView annotationView: MKAnnotationView) {
        
        if annotationView.annotation is MKUserLocation {
            return;
        }else{
            
            let annotation = annotationView.annotation as! RestaurantPointAnnotation
                
            let callout = CalloutRestaurantView(restaurant: annotation.restaurant)
            callout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MapViewController.calloutTapped(_:))))
                
            self.mapView.calloutView?.contentViewInset = UIEdgeInsetsMake(0, 0, 0, 0);
            self.mapView.calloutView!.contentView = callout
                
            self.mapView.calloutView!.presentCalloutFromRect(annotationView.bounds, inView: annotationView, constrainedToView: self.view, animated: true)
        }
        
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        
    }
    
    func calloutTapped(gesture:UITapGestureRecognizer) {
        let callout = gesture.view as! CalloutRestaurantView
        
        let restaurantDetailViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
        restaurantDetailViewController.restaurant = callout.restaurant
        self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        print("selected")
        
        let restaurant = searchResults[indexPath.row]
        
        let location = CLLocation(latitude: CLLocationDegrees(restaurant.latitude) , longitude: CLLocationDegrees(restaurant.longitude))
        
        let annotation = RestaurantPointAnnotation(restaurant: restaurant, coordinate: location.coordinate)
        self.mapView.addAnnotation(annotation)
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate, 300, 300)
        self.mapView.setRegion(region, animated: true)
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = btnSearch
        self.segmentHeightConstraint.constant = 50
        self.segmentView.hidden = false
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
        self.segmentHeightConstraint.constant = 0
        self.segmentView.hidden = true
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.navigationItem.rightBarButtonItem = nil
        self.segmentHeightConstraint.constant = 0
        self.segmentView.hidden = true
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}
