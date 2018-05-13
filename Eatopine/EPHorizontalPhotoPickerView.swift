//
//  EPHorizontalPhotoPickerView.swift
//  Eatopine
//
//  Created by Borna Beakovic on 14/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit


let photoLimit = 5

class EPHorizontalPhotoPickerView: UIView,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    private var view: UIView!
    
    private var saveMedia:Bool?
    private var canPickPhoto = true
    private var photoAddedArray = [UIImage]()
    
    private var topViewController:UIViewController!
    @IBOutlet weak private var collection: UICollectionView!
    
    
    override init(frame: CGRect) {
        // 1. setup any properties here
        
        // 2. call super.init(frame:)
        super.init(frame: frame)
        
        // 3. Setup view from .xib file
        xibSetup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        // 1. setup any properties here
        
        // 2. call super.init(coder:)
        super.init(coder: aDecoder)
        
        // 3. Setup view from .xib file
        xibSetup()
        
        collection.registerNib(UINib(nibName: "EPHorizontalPickerCollectionCell", bundle: nil) , forCellWithReuseIdentifier: "PhotoPickerCell")
    }
    
    func xibSetup() {
        view = loadViewFromNib()
        
        // use bounds not frame or it'll be offset
        view.frame = bounds
        
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.FlexibleWidth, UIViewAutoresizing.FlexibleHeight]
        
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: "EPHorizontalPhotoPickerView", bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    
    func setPresentingController(viewController:UIViewController) {
        topViewController = viewController
    }
    
    func getPhotos() -> [UIImage]{
        return photoAddedArray
    }
    
    // MARK: CollectionView delegate and datasource methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if canPickPhoto == true {
            return photoAddedArray.count+1
        }else{
            return photoAddedArray.count
        }
        
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoPickerCell", forIndexPath: indexPath) as! EPHorizontalPickerCollectionCell
        cell.btnRemove.tag = indexPath.row
        cell.btnRemove.addTarget(self, action: #selector(EPHorizontalPhotoPickerView.removePhoto(_:)), forControlEvents: UIControlEvents.TouchDown)
        
        if indexPath.row == photoAddedArray.count && canPickPhoto == true {
            // this is last cell, show AddNewPhotoCell
            cell.photo.image = UIImage(named: "placeholderAddPhoto")
            cell.btnRemove.hidden = true
        }else{
            let photo = photoAddedArray[indexPath.row]
            cell.photo.image = photo
            cell.btnRemove.hidden = false
        }
        
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(100, 100)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 16, 0, 0)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == photoAddedArray.count && canPickPhoto == true {
            //AddNewPhotoCell clicked
                showImagePicker()
        }
    }
    
    
    func removePhoto(button:UIButton) {
        photoAddedArray.removeAtIndex(button.tag)
        if photoAddedArray.count < photoLimit {
            canPickPhoto = true
        }else{
            canPickPhoto = false
        }
        self.collection.reloadData()
    }
    
    func showImagePicker() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takeButton = UIAlertAction(title: "Take a photo", style: UIAlertActionStyle.Default, handler: { (takeButton:UIAlertAction) -> Void in
            print("")
            self.alertControllerClickedButtonAtIndex(0)
        })
        alertController.addAction(takeButton)
        let chooseButton = UIAlertAction(title: "Choose from gallery", style: UIAlertActionStyle.Default, handler: { (chooseButton:UIAlertAction) -> Void in
            self.alertControllerClickedButtonAtIndex(1)
        })
        alertController.addAction(chooseButton)
        let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
        alertController.addAction(cancelButton)
        topViewController.presentViewController(alertController, animated: true, completion: nil)
    }
    
    //MARK: UIActionSheet delegate methods
    func alertControllerClickedButtonAtIndex(buttonIndex: Int) {
        if buttonIndex == 2 {
            return
        }
        
        let photoPicker = UIImagePickerController()
        photoPicker.title = "Pick photo"
        photoPicker.delegate = self
        photoPicker.allowsEditing = true
        //  photoPicker.navigationBar.tintColor = UIColor.whiteColor()
        photoPicker.navigationBar.translucent = false
        photoPicker.navigationBar.barStyle = UIBarStyle.Black;
        photoPicker.navigationBar.barTintColor = COLOR_EATOPINE_RED
        photoPicker.navigationBar.tintColor =  UIColor.whiteColor()
        
        
        if buttonIndex == 0 {
            // Take a photo pressed
            photoPicker.sourceType = UIImagePickerControllerSourceType.Camera
            saveMedia = true
            
        } else if buttonIndex == 1 {
            // Choose from library pressed
            photoPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            saveMedia = false
        }
        
        topViewController.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedPhoto = info[UIImagePickerControllerEditedImage] as! UIImage
        let resizedPhoto = RBResizeImage(pickedPhoto,targetSize: CGSizeMake(800, 800))
        
        photoAddedArray.append(resizedPhoto)
        
        var lastRow = 0
        if photoAddedArray.count < photoLimit {
            canPickPhoto = true
            lastRow = photoAddedArray.count
        }else{
            canPickPhoto = false
            lastRow = photoAddedArray.count-1
        }
        self.collection.reloadData()
        
        
        
        self.collection.scrollToItemAtIndexPath(NSIndexPath(forRow:lastRow, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.None, animated: false)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}








