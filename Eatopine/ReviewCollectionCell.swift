//
//  ReviewCollectionCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 07/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

class ReviewCollectionCell: BaseCollectionTableViewCell {

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        if let photo = objectArray[indexPath.row] as? EPPhoto {
            //    cell.photo.layer.cornerRadius = 10
            //  cell.photo.clipsToBounds = true
            var imagePlaceholder = ""
            if photo.dish_id != nil {
                imagePlaceholder = "dish_placeholder"
            }else{
                imagePlaceholder = "restaurant_placeholder"
            }
            cell.photo.sd_setImageWithURL(NSURL(string: photo.url), placeholderImage:UIImage(named: imagePlaceholder))
        }
        return cell
    }

}
