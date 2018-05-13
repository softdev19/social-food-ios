//
//  DishPageViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 16/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class DishPageViewController: UIViewController,UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    @IBOutlet weak private var dishNumberLabel:UILabel!
    @IBOutlet weak private var btnPrev:UIButton!
    @IBOutlet weak private var btnNext:UIButton!
    @IBOutlet weak private var publishButton: UIButton!
    
    private var pageViewController: UIPageViewController!
    private var currentIndex = 0
    
    var dishArray = [EPDish]()
    var startAtIndex:Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let backButton = UIBarButtonItem(title: "back", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(DishPageViewController.popController))
        self.navigationItem.leftBarButtonItem = backButton

        
        createPageViewController()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    private func createPageViewController() {
        
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageViewController.dataSource = self
        pageViewController.delegate = self
        showPageAtIndex(startAtIndex, direction: .Forward)

        pageViewController.view.frame = CGRect(x: self.view.frame.origin.x,y: self.view.frame.origin.y+36,width: self.view.frame.size.width,height: self.view.frame.size.height-36)
        
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMoveToParentViewController(self)
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.whiteColor()
        appearance.backgroundColor = UIColor.darkGrayColor()
    }
    
    
    //MARK: Actions
    @IBAction func nextPage(){
        
        let newIndex = currentIndex + 1
        showPageAtIndex(newIndex, direction: UIPageViewControllerNavigationDirection.Forward)
    }
    
    @IBAction func prevPage() {
        let newIndex = currentIndex - 1
        showPageAtIndex(newIndex, direction: UIPageViewControllerNavigationDirection.Reverse)
    }
    
    func showPageAtIndex(index:Int, direction:UIPageViewControllerNavigationDirection) {
        let pageAtIndex = getItemController(index)
        if pageAtIndex != nil {
            currentIndex = index
            pageViewController.setViewControllers([pageAtIndex!], direction: direction, animated: true, completion: nil)
            configureNextPrevButtonAndLabel()
        }
    }
    
    func popController() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! DishDetailTableViewController
    //    currentIndex = itemController.itemIndex
        if itemController.itemIndex > 0 {
            return getItemController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! DishDetailTableViewController
    //    currentIndex = itemController.itemIndex
        if itemController.itemIndex+1 < dishArray.count {
            return getItemController(itemController.itemIndex+1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        currentIndex = (pageViewController.viewControllers![0] as! DishDetailTableViewController).itemIndex
        
        configureNextPrevButtonAndLabel()
    }
    
    private func getItemController(itemIndex: Int) -> DishDetailTableViewController? {
        
        if itemIndex < dishArray.count {
            let pageItemController = self.storyboard!.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
            //pageItemController.dish = dishArray[itemIndex]
            pageItemController.itemIndex = itemIndex
            return pageItemController
        }
        
        return nil
    }

    
    func configureNextPrevButtonAndLabel() {
        
        if dishArray.count == 1 {
            btnPrev.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            btnPrev.enabled = false
            btnNext.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            btnNext.enabled = false
        }else if currentIndex == 0 {
            btnPrev.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            btnPrev.enabled = false
            
            btnNext.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            btnNext.enabled = true
        }else if currentIndex == dishArray.count-1 {
            btnNext.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            btnNext.enabled = false
            btnPrev.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            btnPrev.enabled = true
        }else{
            btnPrev.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            btnNext.setTitleColor(COLOR_EATOPINE_RED, forState: UIControlState.Normal)
            btnPrev.enabled = true
            btnNext.enabled = true
        }
        
        dishNumberLabel.text = "\(currentIndex+1) of \(dishArray.count) dishes"
    }
    
}
