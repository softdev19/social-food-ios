//
//  ReportViewController.swift
//  Eatopine
//
//  Created by  on 9/24/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

enum ReportType : String {
    case rating
    case comment
    case restaurant
    case dish
}

class ReportViewController: UIViewController {
    
    var dish:EPDish?
    var type = ""
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onReportBtnClick(sender: UIButton) {
        var reason = ""
        if sender.tag == 0 {
            let alertController = UIAlertController(title: "Are you sure?", message: "Are you really sure to report this post as spam?", preferredStyle: UIAlertControllerStyle.Alert)
            let report = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (alertButton: UIAlertAction) in
                reason = "spam"
                self.reportAction(reason)
            })
            report.setValue(UIColor.redColor(), forKey: "titleTextColor")
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (alertButton: UIAlertAction) in
            })
            alertController.addAction(report)
            alertController.addAction(cancel)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else if sender.tag == 1 {
            let alertController = UIAlertController(title: "Are you sure?", message: "Are you really sure to report this post as offensive?", preferredStyle: UIAlertControllerStyle.Alert)
            let report = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (alertButton: UIAlertAction) in
                reason = "offensive"
                self.reportAction(reason)
            })
            report.setValue(UIColor.redColor(), forKey: "titleTextColor")
            let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Default, handler: { (alertButton: UIAlertAction) in
            })
            alertController.addAction(report)
            alertController.addAction(cancel)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        else {
            let alertController = UIAlertController(title: "Are you sure?", message: "Thank you for reporting us this post.", preferredStyle: UIAlertControllerStyle.Alert)
            let report = UIAlertAction(title: "Report", style: UIAlertActionStyle.Default, handler: { (alertButton: UIAlertAction) in
                reason = "nolike"
                self.reportAction(reason)
            })
            alertController.addAction(report)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func reportAction(reason:String) {
        if type == ReportType.rating.rawValue {
            EatopineAPI.report(dish!.rating_id, type: type, reason: reason, completionClosure: { (success) in
                if success {
                    print("Report is Success")
                }
            })
        }
    }
}
