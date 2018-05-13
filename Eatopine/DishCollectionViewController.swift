//
//  DishCollectionViewController.swift
//  Eatopine
//
//  Created by  on 10/17/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class DishCollectionViewController: UICollectionViewController {
    
    private var resDishes = [EPResDish]()
    private var searchDishes = [EPSearchDish]()
    var restaurant:EPRestaurant!
    var fromRestaurant = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadDishes("")
    }
    
    func downloadDishes(searchString: String) {
        if fromRestaurant {
            AppUtility.showActivityOverlay("Loading")
            EatopineAPI.downloadRestaurantDishes(restaurant.id, page: 0, completionClosure: { (success, dishes) -> () in
                AppUtility.hideActivityOverlay()
                if dishes != nil {
                    self.resDishes = dishes!
                }
                self.collectionView?.reloadData()
            })
        }
        else {
            AppUtility.showActivityOverlay("Loading")
            LocationManager.getCurrentUserLocation({ (location, error) in
                if error == nil {
                    EatopineAPI.downloadDishInSearch(location!, order: "rating_desc", price: "1", vote: "0", type: "Starter", pageNum: 0, completionClosure: { (success, dishes) in
                        AppUtility.hideActivityOverlay()
                        if dishes == nil {
                            self.searchDishes = [EPSearchDish]()
                        }
                        else {
                            self.searchDishes = dishes!
                        }
                        self.collectionView?.reloadData()
                    })
                }
                else {
                    AppUtility.hideActivityOverlay()
                    AppUtility.showAlert(error!.localizedDescription, title: "Location error")
                }
            })
        }
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let cellsAcross: CGFloat = 2
        let spaceBetweenCells: CGFloat = 2
        let dim = (collectionView.bounds.width - 10 - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSizeMake(dim, dim + 55)
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return dishes.count
        if fromRestaurant {
            if resDishes.count == 0 {
                return 0
            }
            return 10
        }
        else {
            return searchDishes.count
        }
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DishCell", forIndexPath: indexPath) as! DishCell
        
        if fromRestaurant {
            //let dish = dishes[indexPath.row]
            let dish = resDishes[0]
            cell.imgDish.sd_setImageWithURL(NSURL(string: dish.photo), placeholderImage: UIImage(named: "dish_placeholder"))
            cell.lblName.text = dish.name
            cell.ratingView.setupForEatopineSmall()
            cell.ratingView.rating = CGFloat(dish.vote)
            cell.lblLocation.text = restaurant.address
        }
        else {
            let dish = searchDishes[indexPath.row]
            cell.imgDish.sd_setImageWithURL(NSURL(string: dish.dish_photo), placeholderImage: UIImage(named: "dish_placeholder"))
            cell.lblName.text = dish.dishName
            cell.ratingView.setupForEatopineSmall()
            cell.ratingView.rating = CGFloat(dish.vote)
            cell.lblLocation.text = dish.restaurantName
        }
        return cell
    }
}

class DishCell: UICollectionViewCell {
    @IBOutlet weak var imgDish: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblLocation: UILabel!
    @IBOutlet weak var ratingView: EatopineRatingView!
}
