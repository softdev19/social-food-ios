//
//  RestaurantOtherInfoTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 13/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class RestaurantOtherInfoTableViewController: UITableViewController {

    @IBOutlet weak var lblWebsite: UILabel!
    @IBOutlet weak var lblTelephone: UILabel!
    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lbCuisine: UILabel!
    @IBOutlet weak var lbAddress: UILabel!
    
    @IBOutlet weak var lblSunday: UILabel!
    @IBOutlet weak var lblMonday: UILabel!
    @IBOutlet weak var lblTuesday: UILabel!
    @IBOutlet weak var lblWednesday: UILabel!
    @IBOutlet weak var lblThursday: UILabel!
    @IBOutlet weak var lblFriday: UILabel!
    @IBOutlet weak var lblSaturday: UILabel!
    
    var restaurant:EPRestaurant!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = restaurant.name
        updateViewLabels()
    }
    
    func updateViewLabels() {
        lblWebsite.text = restaurant?.website
        lblTelephone.text = restaurant?.tel
        
        if restaurant!.email.characters.count == 0 {
            lblEmail.text = "No email"
        }else{
            lblEmail.text = restaurant?.email
        }
        
        if restaurant.cuisine != nil {
            lbCuisine.text = Global.createJoinedCuisines(restaurant.cuisine!)
        }
        lbAddress.text = restaurant.fullAddress
        
        if (restaurant.hours != nil) {
            let parsedHours = EPRestaurantHours(hoursJSON: restaurant.hours!)
            lblSunday.text = parsedHours.getOpeningHoursForDay("Sunday")
            lblMonday.text = parsedHours.getOpeningHoursForDay("Monday")
            lblTuesday.text = parsedHours.getOpeningHoursForDay("Tuesday")
            lblWednesday.text = parsedHours.getOpeningHoursForDay("Wednesday")
            lblThursday.text = parsedHours.getOpeningHoursForDay("Thursday")
            lblFriday.text = parsedHours.getOpeningHoursForDay("Friday")
            lblSaturday.text = parsedHours.getOpeningHoursForDay("Saturday")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }

    @IBAction func backToPreviousVC(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
