//
//  EPTabBarViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 27/07/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class EPTabBarViewController: UITabBarController, ExplodeControlViewDelegate, UITabBarControllerDelegate {

    let centerButton = UIButton(frame: CGRectMake(0, 0, 50, 50))
    var explodedControlView:ExplodeControlView!
    
    var centerButtonBg:UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        //let emptyItem =  self.tabBar.items![2]
        //emptyItem.enabled = false
        
        //self.tabBar.tintColor = COLOR_EATOPINE_REAL_RED
        centerButtonBg = UIImageView(image: UIImage(named: "explode_tab_bar_bg"))
        centerButtonBg.frame = CGRectMake((self.view.frame.width - centerButtonBg.frame.width) / 2, self.view.frame.height - centerButtonBg.frame.height+4, centerButtonBg.frame.width, centerButtonBg.frame.height)
        //self.view.addSubview(centerButtonBg)
        
        explodedControlView = ExplodeControlView.instanceFromNib()
        explodedControlView.frame = self.view.frame
        explodedControlView.alpha = 0
        explodedControlView.delegate = self
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(EPTabBarViewController.hideExplodeView))
        explodedControlView.addGestureRecognizer(tapGesture)
        
        centerButton.addTarget(self, action: #selector(EPTabBarViewController.centerButtonClicked), forControlEvents: UIControlEvents.TouchDown)
        centerButton.setImage(UIImage(named: "ic_plate_center_not_selected"), forState: UIControlState.Normal)
        centerButton.setImage(UIImage(named: "ic_plate_center_selected"), forState: UIControlState.Selected)
        centerButton.center = centerButtonBg.center
        
        //self.view.addSubview(centerButton)
        
        if AppUtility.isUserLogged(ShowAlert: false) == false {
            let navController = self.storyboard?.instantiateViewControllerWithIdentifier("NotLoggedNavigationController")
            self.viewControllers![4] = navController!
            let navController1 = self.storyboard?.instantiateViewControllerWithIdentifier("NotLoggedNavigationController")
            self.viewControllers![2] = navController1!
        }
        
        var selectedImages = ["home_selected", "map_selected", "camera_selected", "search_selected", "profile_selected"]
        var unselectedImages = ["home", "map", "camera_selected", "search", "profile"]
        
        let items = self.tabBar.items!
        for i in 0 ..< items.count {
            let item = items[i]
            item.selectedImage = UIImage(named: selectedImages[i])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            item.image = UIImage(named: unselectedImages[i])?.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            item.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func hideCenterButton() {
        UIView.animateWithDuration(0.05, animations: {
            self.centerButton.alpha = 0
            self.centerButtonBg.alpha = 0
            }, completion: {
                (value: Bool) in
                
        })
    }
    func showCenterButton() {
        UIView.animateWithDuration(0.05, animations: {
            
            self.centerButton.alpha = 1
            self.centerButtonBg.alpha = 1
            }, completion: {
                (value: Bool) in
                self.view.bringSubviewToFront(self.centerButtonBg)
                self.view.bringSubviewToFront(self.centerButton)
        })
    }
    
    func hideExplodeView() {
        UIView.animateWithDuration(0.2, animations: {
            self.explodedControlView.alpha = 0
            }, completion: {
                (value: Bool) in
                self.explodedControlView.removeFromSuperview()
        })
        
        centerButton.selected = false
    }
    func showExplodeView() {
        UIView.animateWithDuration(0.2, animations: {
            self.view.insertSubview(self.explodedControlView, atIndex: 1)
            self.explodedControlView.alpha = 1
            }, completion: {
                (value: Bool) in
                
        })
        
        centerButton.selected = true
    }
    
    func centerButtonClicked() {
        if centerButton.selected == true{
            hideExplodeView()
        }else{
            showExplodeView()
        }
    }
    
    func explodeViewDidSelectButton() {
        hideExplodeView()
    }
    
    

}
