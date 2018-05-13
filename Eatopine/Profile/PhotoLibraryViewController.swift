//
//  PhotoLibraryViewController.swift
//  Eatopine
//
//  Created by  on 10/16/16.
//  Copyright © 2016 Eatopine. All rights reserved.
//

import UIKit
import Photos

class PhotoLibraryViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var imgSelected: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak private var collectionViewLayout: UICollectionViewFlowLayout!
    
    private var assets: PHFetchResult?
    private var sideSize: CGFloat!
    private var imageCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sideSize = (UIScreen.mainScreen().bounds.width - 3) / 4
        collectionViewLayout.itemSize = CGSize(width: sideSize, height: sideSize)
        collectionViewLayout.minimumLineSpacing = 1
        collectionViewLayout.minimumInteritemSpacing = 1
        
        let imgManager = PHImageManager.defaultManager()
        let requestOptions = PHImageRequestOptions()
        requestOptions.synchronous = true
        
        // Sort the images by creation date
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key:"creationDate", ascending: true)]
        
        if let fetchResult: PHFetchResult = PHAsset.fetchAssetsWithMediaType(PHAssetMediaType.Image, options: fetchOptions) {
            
            if fetchResult.count > 0 {
                // Perform the image request
                imgManager.requestImageForAsset(fetchResult.objectAtIndex(fetchResult.count - 1) as! PHAsset, targetSize: view.frame.size, contentMode: PHImageContentMode.AspectFill, options: requestOptions, resultHandler: { (image, _) in
                    
                    // Add the returned image to your array
                    self.imgSelected.image = image
                })
            }
        }
        
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
        collectionView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func onBackBtnClick(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    @IBAction func onSaveBtnClick(sender: AnyObject) {
        for tempVC in (self.navigationController?.viewControllers)! {
            if tempVC is EditProfileTableViewController {
                (tempVC as! EditProfileTableViewController).newProfilePhoto = imgSelected.image
                self.navigationController?.popViewControllerAnimated(true)
            }
        }
    }
    
    //MARK: CollectionView Protocol
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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("photoCell", forIndexPath: indexPath) as! ImagePickerCell
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let width = self.view.bounds.width
        let height = self.view.bounds.height
        let options = PHImageRequestOptions()
        options.deliveryMode = .HighQualityFormat
        options.resizeMode = .Exact
            
        PHImageManager.defaultManager().requestImageForAsset(assets?[imageCount - indexPath.row - 1] as! PHAsset, targetSize: CGSizeMake(width, height), contentMode: .AspectFill, options: options) { (image: UIImage?, info: [NSObject: AnyObject]?) -> Void in
            if let _image = image {
                print("Show Filer View")
                self.imgSelected.image = _image
            }
        }
        
    }

}
