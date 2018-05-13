//
//  HotDishCollectionTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 10/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit


class HotDishCollectionTableViewCell: BaseCollectionTableViewCell {
    

    override func downloadData() {
        EatopineAPI.downloadDishesForCity(DefaultCityController.getDefault(), page: 0, completionClosure: { (success, dishes) -> () in
            if dishes != nil {
                self.objectArray = dishes!
                self.collection.reloadData()
            }
        })
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        if let dish = objectArray[indexPath.row] as? EPDish {
            cell.lblName.text = dish.name
            //     cell.photo.smallBottomToTopGradient()
            cell.photo.layer.cornerRadius = 10
            cell.photo.clipsToBounds = true
            
            cell.photo.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage:UIImage(named: "dish_placeholder"))
        }
        return cell
    }
    
    
    /*
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return dishesArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        let dish = dishesArray[indexPath.row]
        
        cell.lblName.text = dish.name
   //     cell.photo.smallBottomToTopGradient()
        cell.photo.layer.cornerRadius = 10
        cell.photo.clipsToBounds = true
        
        cell.photo.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage:UIImage(named: "dish_placeholder"))
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectDish(dishesArray, atIndex: indexPath.row)
    }
    */
}
