//
//  RestaurantHoursTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class RestaurantHoursTableViewController: UITableViewController {

    @IBOutlet weak var lblSunday: UILabel!
    @IBOutlet weak var lblMonday: UILabel!
    @IBOutlet weak var lblTuesday: UILabel!
    @IBOutlet weak var lblWednesday: UILabel!
    @IBOutlet weak var lblThursday: UILabel!
    @IBOutlet weak var lblFriday: UILabel!
    @IBOutlet weak var lblSaturday: UILabel!
    
    var restaurant:EPRestaurant!
  //  var restaurantHours:EPRestaurantHours?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(RestaurantHoursTableViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton
        self.title = restaurant.name
        updateViewLabels()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func updateViewLabels() {
        let parsedHours = EPRestaurantHours(hoursJSON: restaurant.hours!)
         lblSunday.text = parsedHours.getOpeningHoursForDay("Sunday")
         lblMonday.text = parsedHours.getOpeningHoursForDay("Monday")
         lblTuesday.text = parsedHours.getOpeningHoursForDay("Tuesday")
         lblWednesday.text = parsedHours.getOpeningHoursForDay("Wednesday")
         lblThursday.text = parsedHours.getOpeningHoursForDay("Thursday")
         lblFriday.text = parsedHours.getOpeningHoursForDay("Friday")
         lblSaturday.text = parsedHours.getOpeningHoursForDay("Saturday")

    }
    
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
}

