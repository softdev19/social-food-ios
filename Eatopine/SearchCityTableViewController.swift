//
//  SearchCityTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 03/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

protocol SearchCityDelegate {
    func didSelectCity(city:String, state:String)
}

class SearchCityTableViewController: UITableViewController, UISearchBarDelegate {

    enum Section : Int {
        case CurrentLocation = 0
        case CityList
    }
    
    var delegate: SearchCityDelegate?
    @IBOutlet weak var searchBar: UISearchBar!
    var cityArray = [CityDetails]()
    var shouldReturnSelectedCity = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.backgroundImage = UIImage()
        searchBar.layer.borderWidth = 1
        searchBar.layer.borderColor = UIColor.clearColor().CGColor
        searchBar.setCursorColor(COLOR_EATOPINE_RED)
    }

    override func viewDidAppear(animated: Bool) {
        let delayTime = dispatch_time(DISPATCH_TIME_NOW, Int64(0.1 * Double(NSEC_PER_SEC)))
        dispatch_after(delayTime, dispatch_get_main_queue()) {
            self.searchBar.becomeFirstResponder()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.view.endEditing(true)
    }

    func makeSearch(text:String) {
        
        EatopineAPI.searchCity(text, completionClosure: { (success, cities) -> () in
            self.cityArray = cities!
            self.tableView.reloadData()
        })
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == Section.CurrentLocation.rawValue {
            return ""
        }else{
            return "Cities"
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        if section == Section.CurrentLocation.rawValue {
            return 1
        }else{
            return cityArray.count
        }
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("CityCell", forIndexPath: indexPath) 

        if indexPath.section == Section.CurrentLocation.rawValue {
            cell.textLabel?.text = "Current location"
            cell.accessoryView = UIImageView(image: UIImage(named: "locationIndicator"))
        }else{
            let city = cityArray[indexPath.row]
            cell.textLabel?.text = "\(city.name), \(city.state)"
            cell.accessoryView = nil
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        //let row = indexPath.row
     
        if section == Section.CurrentLocation.rawValue {
            // use current location to search restaurants

            AppUtility.showActivityOverlay("Locating")
            LocationManager.getCurrentUserLocation({ (location, error) -> () in
                if error == nil {
                    // now try getting city name and state
                    LocationManager.reverseGeocode(location!, completionClosure: { (placemark, error) -> () in
                        AppUtility.activityOverlay.titleLabelText = "Loading"
                        let latitude = Float(location!.coordinate.latitude)
                        let longitude = Float(location!.coordinate.longitude)
                        var city = ""
                        var state = ""
                        
                        if error == nil{
                            // save received info as default city
                            city = placemark!.locality!
                            state = placemark!.administrativeArea!
                        }
                        if self.shouldReturnSelectedCity == true {
                            AppUtility.hideActivityOverlay()
                            self.delegate?.didSelectCity(city, state: state)
                        }else{
                            DefaultCityController.setDefaultCity(city, state:state , lat: latitude, lng: longitude)
                         //   NotificationCenter.postNotificationName("SearchScreenNeedsRefresh", object: nil)
                        }
                        
                        // mark List as Needed refresh because filter changed
                        UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
                        UserDefaults.synchronize()
                        self.dismissViewControllerAnimated(true, completion: nil)
                    })
                    
                }else{
                    AppUtility.hideActivityOverlay()
                    AppUtility.showAlert(error!.localizedDescription, title: "Location error")
                }
            })
        }else{
            let city = cityArray[indexPath.row]
            if self.shouldReturnSelectedCity == true {
                delegate?.didSelectCity(city.name, state: city.state)
            }else{
                AppUtility.showActivityOverlay("Loading")
                DefaultCityController.setDefaultCity(city)
                
                
               // NotificationCenter.postNotificationName("SearchScreenNeedsRefresh", object: nil)
            }
            // mark List as Needed refresh because filter changed
            UserDefaults.setBool(true, forKey: LIST_NEEDS_REFRESH)
            UserDefaults.synchronize()
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    
    //MARK: UISearchBar delegate
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.characters.count > 2 {
            makeSearch(searchText)
        }
    }
    
}
