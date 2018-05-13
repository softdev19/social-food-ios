//
//  ReportViewController.swift
//  Eatopine
//
//  Created by  on 10/17/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ProfileReportViewController: UITableViewController {
    
    @IBOutlet weak var txtReport: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func onCancelBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onSendBtnClick(sender: AnyObject) {
        if txtReport.text == "" {
            AppUtility.showAlert("Please input report", title: "Empty")
            txtReport.becomeFirstResponder()
            return
        }
        
        AppUtility.showActivityOverlaySuccessAndHideAfterDelay("")
        EatopineAPI.supportReport(AppUtility.currentUserId.integerValue, report: txtReport.text!) { (success) in
            if success {
                AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                self.navigationController?.popViewControllerAnimated(true)
            }
            else {
                AppUtility.hideActivityOverlay()
            }
        }
    }
}
