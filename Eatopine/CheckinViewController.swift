//
//  CheckinViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 05/09/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import SZTextView
import FBSDKCoreKit
import FBSDKShareKit
import FBSDKLoginKit
import TwitterKit
import TwitterCore
import SwiftyJSON

class CheckinViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate, FBSDKSharingDelegate, EPFacebookDelegate, EatopineSearchControllerDelegate, UITextViewDelegate {

    @IBOutlet weak private var restaurantPhoto: UIImageView!
    @IBOutlet weak private var photoView: UIImageView!
    @IBOutlet weak private var btnAddPhoto: UIButton!
    @IBOutlet weak private var btnRemovePhoto: UIButton!
    
    @IBOutlet weak private var lblRestaurantName: UILabel!
    @IBOutlet weak private var lblRestaurantAddress: UILabel!
    @IBOutlet weak private var lblDistance: UILabel!
    @IBOutlet weak var textView: SZTextView!
    @IBOutlet weak private var textViewCloseButton: UIButton!
    
    @IBOutlet weak private var backButton: UIBarButtonItem!
    @IBOutlet weak private var swcFacebook: UISwitch!
    @IBOutlet weak private var swcTwitter: UISwitch!
    
    var showRestaurantPageWhenFinish = false
    var restaurant:EPRestaurant!
    private var saveMedia:Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(CheckinViewController.endEditing))
        self.view.addGestureRecognizer(tapGesture)

        photoView.clipsToBounds = true
        swcFacebook.transform = CGAffineTransformMakeScale(0.80, 0.80);
        swcTwitter.transform = CGAffineTransformMakeScale(0.80, 0.80);
        swcFacebook.setOn(PersistancyManager.isFacebookSharingActive(), animated: false)
        swcTwitter.setOn(PersistancyManager.isTwitterSharingActive(), animated: false)
        
        if self.navigationController?.viewControllers.count > 1 {
            backButton.title = "back"
        }else{
            backButton.title = "close"
        }
        
        updateViewLabels()
        
    }

    func endEditing(){
        self.view.endEditing(true)
    }
    
    override func viewDidLayoutSubviews() {
        updateViewLabels()
    }
    
    func updateViewLabels() {
        if restaurant != nil {
            lblRestaurantName.text = restaurant.name
            lblRestaurantAddress.text = restaurant.fullAddress
            lblDistance.text = AppUtility.distanceFromRestaurantInMiles(restaurant)
            restaurantPhoto.sd_setImageWithURL(NSURL(string: restaurant.photo), placeholderImage:UIImage(named: "restaurant_placeholder"))
        }
        
        if photoView.image != nil {
            btnRemovePhoto.hidden = false
            btnAddPhoto.hidden = true
        }else{
            btnRemovePhoto.hidden = true
            btnAddPhoto.hidden = false
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func addPhoto(sender: AnyObject?) {
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
        self.presentViewController(alertController, animated: true, completion: nil)
    }
    
    @IBAction func postCheckin(sender: AnyObject?) {
        if isInputValid() {
            self.view.endEditing(true)
            AppUtility.showActivityOverlay("Checking in...")
            EatopineAPI.checkinToRestaurant(restaurant.id, text: textView.text, photo: photoView.image, completionClosure: { (success) -> () in
                
                if self.swcFacebook.on == true {
                    self.shareOnFacebook()
                }

                if self.swcTwitter.on == true {
                    self.shareOnTwitter()
                }

                if success {
                    AppUtility.showActivityOverlaySuccessAndHideAfterDelay("Success")
                }else{
                    AppUtility.hideActivityOverlay()
                }
                if self.showRestaurantPageWhenFinish == true {
                    let restaurantDetailViewController = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantDetailTableViewController") as! RestaurantDetailTableViewController
                    restaurantDetailViewController.restaurant = self.restaurant
                    self.navigationController?.pushViewController(restaurantDetailViewController, animated: true)
                }else{
                    self.dismissViewControllerAnimated(true, completion: nil)
                }
                
            })
            
        }
    }
    
    @IBAction func backPressed(sender: AnyObject?) {
        if self.navigationController?.viewControllers.count > 1 {
            // go to restaurant search
            self.navigationController?.popToRootViewControllerAnimated(true)
        } else {
            // close
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    @IBAction func facebookSharingPresse(sender: UISwitch) {
        PersistancyManager.setFacebookSharing(sender.on)
    }
    
    @IBAction func twitterSharingPresse(sender: UISwitch) {
        PersistancyManager.setTwitterSharing(sender.on)
    }
    
    @IBAction func removePhoto(sender: UIButton) {
        photoView.image = nil
        updateViewLabels()
    }
    
    func isInputValid() -> Bool {
        
        if textView.text == ""{
            AppUtility.showAlert("Please write a comment", title: "Notice")
            return false
        }
        
        return true
    }
    
    //MARK: Sharing
    
    func shareOnFacebook() {

        if FBSDKAccessToken.currentAccessToken() != nil {
            facebookSearchPlace()
        }else{
            ApplicationDelegate.facebookLogin(self,downloadUserProfile:true)
        }
    }

    //MARK: FacebookDelegate methods
    
    func didLoginToFacebook(userProfileJSON: [String : AnyObject]?) {
        // login to Eatopine API
        facebookSearchPlace()
    }
    
    func facebookSearchPlace() {
        
        
        let url = "search?type=place&q=\(self.restaurant.name)&center=\(self.restaurant.latitude),\(self.restaurant.longitude)&distance=10000"
        let encoded = url.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())
        print("encoded \(encoded)")
        let request = FBSDKGraphRequest(graphPath: encoded, parameters: ["fields":"id, name, location"], HTTPMethod: "GET")
        request.startWithCompletionHandler({ (connection:FBSDKGraphRequestConnection!, result:AnyObject!, error:NSError!) -> Void in
            print("error \(error)")

            if error == nil {
                print("result \(result)")
                
                let json = JSON(result)
                let array = json["data"].arrayValue
                
                if array.count > 1 {
                    let place = array[0].dictionaryValue
                    let placeId = place["id"]!.stringValue
                    print("place \(placeId)")
                    self.facebookShare(placeId)
                }else{
                    self.facebookShare(nil)
                }
                
                
            }else{
                self.facebookShare(nil)
            }
        })
    }
    
    func facebookShare(placeID:String?){
        if photoView.image != nil {
            let facePhoto = FBSDKSharePhoto(image: photoView.image, userGenerated: true)
            
            let content = FBSDKSharePhotoContent()
            content.photos = [facePhoto]
            if placeID != nil {
                content.placeID = placeID
                facePhoto.caption = "\(self.textView.text)"
            }else{
                facePhoto.caption = "\(self.textView.text) \n@ \(self.restaurant.name)"
            }
            FBSDKShareAPI.shareWithContent(content, delegate: self)
        }else{
            
            let content = FBSDKShareLinkContent()
            content.contentURL = NSURL(string:"http://www.eatopine.com")
            if placeID != nil {
                content.placeID = placeID
                content.contentDescription = "\(self.textView.text)"
            }else{
                content.contentDescription = "\(self.textView.text) \n@ \(self.restaurant.name)"
            }
            FBSDKShareAPI.shareWithContent(content, delegate: self)
        }
    }
    
    func sharer(sharer: FBSDKSharing!, didCompleteWithResults results: [NSObject : AnyObject]!) {
        print("Shared on FACEBOOK")
    }
    func sharer(sharer: FBSDKSharing!, didFailWithError error: NSError!) {
        
        print("Facebook sharing error %@", error)
    }
    
    func sharerDidCancel(sharer: FBSDKSharing!) {
        print("Facebook sharing canceled")
    }
    
    func shareOnTwitter() {
        
        Twitter.sharedInstance().logInWithCompletion { (session:TWTRSession?, error:NSError?) -> Void in
            var error:NSError?
            let client = Twitter.sharedInstance().APIClient
            
            var params:[String:AnyObject] = ["status":"\(self.textView.text) \n@ \(self.restaurant.name)","lat":"\(self.restaurant.latitude)","long":"\(self.restaurant.longitude)"]
            
            if let photo = self.photoView.image {
                let photoData = UIImageJPEGRepresentation(photo, 0.5)
                let photoString = photoData?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
                let photoParams = ["media_data":photoString as! AnyObject]
                
                let photoRequest = client.URLRequestWithMethod("POST", URL: "https://upload.twitter.com/1.1/media/upload.json", parameters: photoParams, error: &error)
                client.sendTwitterRequest(photoRequest, completion: { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                    if error == nil {
                        let json = EatopineAPI.parseJSON(data!)
                        print("json \(json)")
                        let media_id = json?.objectForKey("media_id_string")
                        
                        params["media_ids"] = media_id
                        
                        var photoError:NSError?
                        
                        print("params \(params)")
                        let tweetRequest = client.URLRequestWithMethod("POST", URL: "https://api.twitter.com/1.1/statuses/update.json", parameters: params, error: &photoError)
                        client.sendTwitterRequest(tweetRequest, completion: { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                            print("response \(response), error \(error)")
                        })
                    }else{
                        print("error \(error)")
                    }
                    
                })
            }else{

                let tweetRequest = client.URLRequestWithMethod("POST", URL: "https://api.twitter.com/1.1/statuses/update.json", parameters: params, error: &error)
                client.sendTwitterRequest(tweetRequest, completion: { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                    print("response \(response), error \(error)")
                })
            }
        }
    }
    
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
        
        self.presentViewController(photoPicker, animated: true, completion: nil)
    }
    
    //MARK: UIImagePickerControllerDelegate methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let pickedPhoto = info[UIImagePickerControllerEditedImage] as! UIImage
        let resizedPhoto = RBResizeImage(pickedPhoto,targetSize: CGSizeMake(800, 800))
        
        photoView.image = resizedPhoto
        updateViewLabels()
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //MARK: EPFacebook delegate methods
    
    func didReturnFromAskingPublishPermission(didGetPermission: Bool) {
        if didGetPermission == true{
            postCheckin(nil)
        }
    }
    
    //MARK: EatopineSearchControllerDelegate
    func didSelect(object: AnyObject) {
        
        restaurant = object as! EPRestaurant
        print("obj \(restaurant.name)")
     //   updateViewLabels()
    }
    
    
    @IBAction func closeTextView(){
        textView.resignFirstResponder()
    }
    
    //MARK: UITextViewDelegate
    
    func textViewDidBeginEditing(textView: UITextView) {
        textViewCloseButton.hidden = false
    }
    func textViewDidEndEditing(textView: UITextView) {
        textViewCloseButton.hidden = true
        
    }
}
