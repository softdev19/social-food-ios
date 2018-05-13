//
//  DishPhotosViewController.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/10/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class DishPhotosViewController: UIViewController ,UICollectionViewDelegate, UICollectionViewDataSource{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cell", forIndexPath: indexPath) as! PhotosCollectionViewCell
        cell.imagePhoto.image = UIImage(named: "dish_small_image.png")
        //        let dish = list[indexPath.row]
        //        cell.imgFood.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
