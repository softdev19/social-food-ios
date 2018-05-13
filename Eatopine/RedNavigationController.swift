//
//  RedNavigationController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 01/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class RedNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.translucent = false
        self.navigationBar.barStyle = UIBarStyle.Black;
        self.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        self.navigationBar.tintColor =  UIColor.whiteColor()
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: .Default)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
