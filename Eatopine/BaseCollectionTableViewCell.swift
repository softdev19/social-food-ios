//
//  BaseCollectionTableViewCell.swift
//  Eatopine
//
//  Created by Borna Beakovic on 04/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit

protocol PhotoCollectionCellDelegate {
    func didSelectPhotoCell(objects:[AnyObject], atIndex:Int)
}

class BaseCollectionTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    var delegate: PhotoCollectionCellDelegate?
    @IBOutlet weak var collection: UICollectionView!
    var objectArray = [AnyObject]()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if collection != nil {
            
            collection.delegate = self
            collection.dataSource = self
           // downloadData()
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func downloadData() {
        
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return objectArray.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! PhotoCollectionViewCell
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsZero
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        delegate?.didSelectPhotoCell(objectArray, atIndex: indexPath.row)
    }
}
