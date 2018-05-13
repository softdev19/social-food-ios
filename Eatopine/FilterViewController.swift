//
//  FilterViewController.swift
//  Eatopine
//
//  Created by  on 9/27/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imgCapturedImage: UIImageView!
    
    @IBOutlet weak var filterCollectionView: UICollectionView!
    var capturedImage: UIImage!
    var staticPicture: GPUImagePicture!
    var instaFilters: [AnyClass]!
    var filterImages: [UIImage]!
    var filterNames = ["Normal", "Clarendon", "Gingham", "Moon", "Lark", "Reyes", "Juno"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        imgCapturedImage.image = capturedImage
        instaFilters = IFImageFilter.allFilterClasses()
        filterImages = [UIImage]()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()

        //        self.filterCollectionView.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        for i in 0 ..< 6 {
            let filter = (self.instaFilters[i] as! IFImageFilter.Type).init()
            let image = filter.imageByFilteringImage(self.capturedImage)
            self.filterImages.append(image)
        }
        
        self.filterCollectionView.reloadData()
    }
    
    @IBAction func onBackBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }

    @IBAction func onAvantiBtnClick(sender: UIBarButtonItem) {
        let addRatingViewController = storyboard?.instantiateViewControllerWithIdentifier("AddRatingViewController") as! AddRatingViewController
        addRatingViewController.dishImage = self.imgCapturedImage.image
        self.navigationController?.pushViewController(addRatingViewController, animated: true)
    }
    
    //MARK: CollectionView Protocol
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("filterCell", forIndexPath: indexPath) as! FilterCell
        
        if indexPath.row == 0 {
            cell.filterImage.image = capturedImage
        }
        else if filterImages.count > indexPath.row - 1 {
            cell.filterImage.image = filterImages[indexPath.row - 1]
        }
        else {
            cell.filterImage.image = capturedImage
        }
        cell.filterLabel.text = filterNames[indexPath.row]
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {
            imgCapturedImage.image = capturedImage
        }
        else if filterImages.count > indexPath.row - 1 {
            imgCapturedImage.image = filterImages[indexPath.row - 1]
        }
        else {
            imgCapturedImage.image = capturedImage
        }
    }
}

class FilterCell: UICollectionViewCell {
    @IBOutlet weak var filterLabel: UILabel!
    @IBOutlet weak var filterImage: UIImageView!
}
