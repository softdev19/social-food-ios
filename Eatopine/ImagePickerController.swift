//
//  ImagePickerController.swift
//  Eatopine
//
//  Created by  on 9/27/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import Photos

class ImagePickerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var lblPhotoNumber: UILabel!
    
    private var assets: PHFetchResult?
    private var sideSize: CGFloat!
    private var imageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
        
        sideSize = (UIScreen.mainScreen().bounds.width - 3) / 4
        collectionViewLayout.itemSize = CGSize(width: sideSize, height: sideSize)
        collectionViewLayout.minimumLineSpacing = 1
        collectionViewLayout.minimumInteritemSpacing = 1
        
        if PHPhotoLibrary.authorizationStatus() == .Authorized {
            reloadAssets()
        } else {
            PHPhotoLibrary.requestAuthorization({ (status: PHAuthorizationStatus) -> Void in
                if status == .Authorized {
                    self.reloadAssets()
                } else {
                    self.showNeedAccessMessage()
                }
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.barTintColor = COLOR_EATOPINE_REAL_RED
    }
    
    private func showNeedAccessMessage() {
        let alert = UIAlertController(title: "Image picker", message: "App need get access to photos", preferredStyle: .Alert)
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (action: UIAlertAction) -> Void in
            UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
        }))
        
        showViewController(alert, sender: nil)
    }
    
    private func reloadAssets() {
        assets = nil
        collectionView.reloadData()
        assets = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: nil)
        lblPhotoNumber.text = "\((assets?.count)! as Int) Photos"
        collectionView.reloadData()
    }

    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        PHImageManager.defaultManager().requestImageForAsset(assets?[imageCount - indexPath.row - 1] as! PHAsset, targetSize: CGSizeMake(sideSize, sideSize), contentMode: .AspectFill, options: nil) { (image: UIImage?, info: [NSObject: AnyObject]?) -> Void in
            (cell as! ImagePickerCell).image = image
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        imageCount = (assets != nil) ? assets!.count : 0
        return imageCount
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ImagePickerCell", forIndexPath: indexPath) as! ImagePickerCell
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if let _storyboard = storyboard {
            let showFilterVC = { (image: UIImage!) -> Void in
                let filterViewController = _storyboard.instantiateViewControllerWithIdentifier("FilterViewController") as! FilterViewController
                
                filterViewController.capturedImage = image
                self.navigationController?.pushViewController(filterViewController, animated: true)
            }
            
            let width = self.view.bounds.width
            let height = self.view.bounds.height
            let options = PHImageRequestOptions()
            options.deliveryMode = .HighQualityFormat
            options.resizeMode = .Exact
            
            PHImageManager.defaultManager().requestImageForAsset(assets?[imageCount - indexPath.row - 1] as! PHAsset, targetSize: CGSizeMake(width, height), contentMode: .AspectFill, options: options) { (image: UIImage?, info: [NSObject: AnyObject]?) -> Void in
                if let _image = image {
                    print("Show Filer View")
                    showFilterVC(_image)
                }
            }
        }
    }
    
    @IBAction func onCloseBtnClick(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func onSelectBtnClick(sender: UIBarButtonItem) {
        
    }
}

class ImagePickerCell: UICollectionViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    
    var image: UIImage? {
        get {
            return imgView.image
        }
        set {
            imgView.image = newValue
        }
    }
}
