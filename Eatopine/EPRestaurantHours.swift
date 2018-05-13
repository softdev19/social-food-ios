//
//  EPRestaurantHours.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

typealias OpenCloseHours = (openHour:String, closeHour:String)


class EPRestaurantHours: NSObject {
    
    var monday:OpeningHoursDay!
    var tuesday:OpeningHoursDay!
    var wednesday:OpeningHoursDay!
    var thursday:OpeningHoursDay!
    var friday:OpeningHoursDay!
    var saturday:OpeningHoursDay!
    var sunday:OpeningHoursDay!
    
    var currentOpeningHours = [OpenCloseHours]()
    
    init(hoursJSON:AnyObject) {
        
        let JSON = hoursJSON as! [[String:AnyObject]]
        
        monday = OpeningHoursDay()
        tuesday = OpeningHoursDay()
        wednesday = OpeningHoursDay()
        thursday = OpeningHoursDay()
        friday = OpeningHoursDay()
        saturday = OpeningHoursDay()
        sunday = OpeningHoursDay()
        
        for dictObject in JSON {
            
            let day = Int((dictObject["day"] as! String))
            let openString = dictObject["open"] as! String
            let closeString = dictObject["close"] as! String
            let tuple = OpenCloseHours(openString, closeString)
            
            if day == 1 {
                monday.addHours(tuple)
            }else if day == 2 {
                tuesday.addHours(tuple)
            }else if day == 3 {
                wednesday.addHours(tuple)
            }else if day == 4 {
                thursday.addHours(tuple)
            }else if day == 5 {
                friday.addHours(tuple)
            }else if day == 6 {
                saturday.addHours(tuple)
            }else if day == 7 {
                sunday.addHours(tuple)
            }
            
        }
    }
    
    func getOpeningHoursForDay(dayName:String) -> String {
        
        var array = [OpenCloseHours]()
        if dayName == "Monday" {
            array = monday.hours
        }else if dayName == "Tuesday" {
            array = tuesday.hours
        }else if dayName == "Wednesday" {
            array = wednesday.hours
        }else if dayName == "Thursday" {
            array = thursday.hours
        }else if dayName == "Friday" {
            array = friday.hours
        }else if dayName == "Saturday" {
            array = saturday.hours
        }else if dayName == "Sunday" {
            array = sunday.hours
        }
        
        currentOpeningHours = array
        
        if array.count == 1 {
            let hours = array[0]
            return "\(hours.openHour) - \(hours.closeHour)"
        }else if array.count == 2 {
            let hours = array[0]
            let hoursTwo = array[1]
            return "\(hours.openHour) - \(hours.closeHour)\n\(hoursTwo.openHour) - \(hoursTwo.closeHour)"
        }
        
        return "Closed"
    }
    
    func getOpenState() -> Bool {
        var dateFormatter = NSDateFormatter()
        let usLocale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.stringFromDate(NSDate())
        
        var array = [OpenCloseHours]()
        if dayName == "Monday" {
            array = monday.hours
        }else if dayName == "Tuesday" {
            array = tuesday.hours
        }else if dayName == "Wednesday" {
            array = wednesday.hours
        }else if dayName == "Thursday" {
            array = thursday.hours
        }else if dayName == "Friday" {
            array = friday.hours
        }else if dayName == "Saturday" {
            array = saturday.hours
        }else if dayName == "Sunday" {
            array = sunday.hours
        }

        dateFormatter = NSDateFormatter()
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = "HH:mm"
        let time = dateFormatter.stringFromDate(NSDate())
        
        if compareWithOpenHour(time, openTime: array[0].openHour) == true && !compareWithOpenHour(time, openTime: array[0].closeHour) {
            return true
        }
        if array.count == 1 {
            return false
        }
        if array.count == 2 {
            if compareWithOpenHour(time, openTime: array[1].openHour) == true && !compareWithOpenHour(time, openTime: array[1].closeHour) {
                return true
            }
            else {
                return false
            }
        }
        
        return false
    }

    func compareWithOpenHour(currentTime: String, openTime: String) -> Bool {
        
        if openTime == "" {
            return false
        }
        
        let currentSplit = currentTime.componentsSeparatedByString(":")
        let openSplit = openTime.componentsSeparatedByString(":")
        
        let currentHour = Int(currentSplit[0])
        let currentMin = Int(currentSplit[1])
        let openHour = Int(openSplit[0])
        let openMin = Int(openSplit[1])
        
        if (currentHour > openHour) {
            return true
        }
        else if (currentHour == openHour && currentMin > openMin) {
            return true
        }
        return false
    }
    
    func getTodayOpeningHours() -> String{
        let dateFormatter = NSDateFormatter()
        let usLocale = NSLocale(localeIdentifier: "en_US")
        dateFormatter.locale = usLocale
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.stringFromDate(NSDate())
        return getOpeningHoursForDay(dayName)
    }
}


struct OpeningHoursDay {
    var hours:[OpenCloseHours]!
    
    init() {
        self.hours = [OpenCloseHours]()
    }
    
    mutating func addHours(hoursTuple:OpenCloseHours) {
        self.hours.append(hoursTuple)
    }
    
}