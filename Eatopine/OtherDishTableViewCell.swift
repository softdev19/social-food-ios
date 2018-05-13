//
//  OtherDishTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 04/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class OtherDishTableViewCell: HotDishCollectionTableViewCell {

    @IBOutlet weak var buttonLabel: UILabel!
    
    func downloadData(restaurantId:Int) {
        EatopineAPI.downloadRestaurantDishes(restaurantId, page: 0, completionClosure: { (success, dishes) -> () in
            if dishes != nil {
                self.objectArray = dishes!
                self.collection.reloadData()
            }
        })
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        if let dish = objectArray[indexPath.row] as? EPDish {
        //    cell.photo.layer.cornerRadius = 10
          //  cell.photo.clipsToBounds = true
            
            cell.photo.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage:UIImage(named: "dish_placeholder"))
        }
        return cell
    }
}
