//
//  ResturantListTableViewCell.swift
//  Eatopine
//
//  Created by Ourangzaib khan on 9/9/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class ResturantListTableViewCell: UITableViewCell , UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var resturantPhoto: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var resturantName: UILabel!
    @IBOutlet weak var bestDish: UILabel!
    @IBOutlet weak var resturantAddress: UILabel!
    @IBOutlet weak var ratingView: EatopineRatingView!
    @IBOutlet weak var Dishes: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.delegate = self;
        collectionView.dataSource = self;
//        collectionView.registerClass(RestruantCollectionViewCell.self, forCellWithReuseIdentifier: "Cells")
        // Initialization code
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
     func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
     func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
     func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("Cells", forIndexPath: indexPath) as! RestruantCollectionViewCell
        cell.resturantImage.image = UIImage(named: "list_rostni_vector_Smart_object.png")
//        let dish = list[indexPath.row]
//        cell.imgFood.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage: UIImage(named: "restaurant_placeholder"))
        
        return cell
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        
//        let cellsAcross: CGFloat = 3
//        let spaceBetweenCells: CGFloat = 3
//        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
//        return CGSizeMake(dim, dim)
//    }

}
