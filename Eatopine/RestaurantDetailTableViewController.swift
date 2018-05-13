//
//  RestaurantDetailTableViewController.swift
//  Eatopine
//
//  Created by Borna Beakovic on 10/08/15.
//  Copyright (c) 2015 Eatopine. All rights reserved.
//

import UIKit
import SDWebImage
import MapKit

class RestaurantDetailTableViewController: UITableViewController, RestaurantStaticMapViewDelegate,MKMapViewDelegate, FSImageViewerViewControllerDelegate  {

    var restaurantId = 0
    
    @IBOutlet weak var restaurantPhoto: UIImageView!
    @IBOutlet weak var lblName: UILabel!

    @IBOutlet weak var rating: TPFloatRatingView!
    
    // Address
    @IBOutlet weak var lblAddress: UILabel!
    
    // Hours
    @IBOutlet weak var lblOpeningHours: UILabel!
    @IBOutlet weak var lblOpeningState: UILabel!
    @IBOutlet weak var viewHoursContent: UIView!
    var showHoursSection = false
    
    // BestDish section
    @IBOutlet weak var bestDishImageView: ActivityIndicatorImageView!
    @IBOutlet weak var lblDishName: UILabel!
    var showBestDishSection = false
    
    // Menu
    @IBOutlet weak var imgvMenu: UIImageView!
    
    // Photos
    @IBOutlet weak var imgvPhotos: UIImageView!
    var restaurantPhotoArray = [EPPhoto]()
    var photoGallerryCurrentIndex = 0
    
    // Reviews
    @IBOutlet weak var lblReviews: UILabel!
    @IBOutlet weak var imgvReviews: UIImageView!
    
    // Review 1
    @IBOutlet weak var cellReview1: ReviewCell!

    //Review 2
    @IBOutlet weak var cellReview2: ReviewCell!

    //Sample square view
    @IBOutlet weak var sampleSquareView: UIView!
    
    var restaurant:EPRestaurant!
    
    private var reviews = [EPReview]()
    var didDownloadReviews = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if restaurant != nil {
            self.navigationItem.title = self.restaurant.name
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.addressTapped(_:)))
        tapGesture.numberOfTapsRequired = 1
        lblAddress.userInteractionEnabled = true
        lblAddress.addGestureRecognizer(tapGesture)
        
        downloadRestaurantInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    deinit {
        NotificationCenter.removeObserver(self)
    }
    
    override func viewDidAppear(animated: Bool) {
        if self.tabBarController != nil {
            (self.tabBarController as! EPTabBarViewController).showCenterButton()
        }
    }
    
    func downloadRestaurantInfo() {
        if restaurantId == 0 && restaurant != nil {
            restaurantId = restaurant.id
        }
        
        AppUtility.showActivityOverlay("")
        EatopineAPI.downloadRestaurantPage(restaurant.id, completionClosure: { (success, restaurant) -> () in
            AppUtility.hideActivityOverlay()
            if success {
                self.restaurant = restaurant;
                self.updateViewLabels()
            }
        })
    }

    func downloadReviews() {
        EatopineAPI.downloadRestaurantReviews(restaurant.id, page:0, downloadLimit:2, order:"date_desc", completionClosure: { (success, reviews) -> () in
            if success {
                self.reviews = reviews!
                self.updateReviews()
            }
        })
    }
    
    func updateViewLabels() {
        
        self.navigationItem.title = self.restaurant.name
        
        if self.restaurant.best_dish_id != 0 {
            self.showBestDishSection = true
        }
        
        self.rating.setupForEatopineMiddle()
        
        if restaurant.hours != nil && restaurant.hours?.count != 0 {
            self.showHoursSection = true
            
            let parsedHours = EPRestaurantHours(hoursJSON: restaurant.hours!)
            lblOpeningHours.text = parsedHours.getTodayOpeningHours()
            
            if parsedHours.getOpenState() {
                lblOpeningState.text = "Open Now"
                lblOpeningState.textColor = UIColor(red: 20/225, green: 197/225, blue: 12/225, alpha: 1.0)
            }
            else {
                lblOpeningState.text = "Closed Now"
                lblOpeningState.textColor = COLOR_EATOPINE_RED
            }
            
            if lblOpeningHours.text == "Closed" {
                lblOpeningHours.text = ""
            }
        }

        if self.restaurant.number_ratings == 0 {
            lblReviews.text = "Add a Review"
        }else{
            lblReviews.text = "\(restaurant.number_ratings) " + (restaurant.number_ratings == 1 ? "REVIEW" : "REVIEWS")
        }
        
        rating.rating = CGFloat(restaurant.rating)
        lblName.text = restaurant.name
        lblAddress.text = restaurant.fullAddress
        restaurantPhoto.sd_setImageWithURL(NSURL(string: restaurant.photo), placeholderImage:UIImage(named: "sample_header_img.png"))
        
        // best dish
        
        bestDishImageView.sd_setImageWithURL(NSURL(string: restaurant.best_dish_photo), placeholderImage:UIImage(named:"dish_placeholder_big_grey"))
        lblDishName.text = restaurant.best_dish_name
        
        self.tableView.reloadData()
    }
    
    func updateReviews(){
    }
    
    // MARK: - Actions
    
    func popController() {
        if self.presentingViewController != nil {
            self.dismissViewControllerAnimated(true, completion: nil)
        }else{
            self.navigationController?.popViewControllerAnimated(true)
        }
        
    }
    
    @IBAction func callPressed(sender: AnyObject?) {
        let phoneNumberString = "tel://\(restaurant.tel)";
        let trimmedPhone = phoneNumberString.stringByReplacingOccurrencesOfString(" ", withString: "", options: [], range: nil)
        UIApplication.sharedApplication().openURL(NSURL(string:trimmedPhone)!)
    }
    
    
    @IBAction func openInfo(sender: AnyObject?) {
        
        let restaurantInfoViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantOtherInfoTableViewController") as! RestaurantOtherInfoTableViewController
        restaurantInfoViewController.restaurant = restaurant
        self.navigationController?.pushViewController(restaurantInfoViewController, animated: true)
    }
    
    @IBAction func showBestDish() {
        let dishDetailController = storyboard?.instantiateViewControllerWithIdentifier("DishDetailTableViewController") as! DishDetailTableViewController
             dishDetailController.dishId = restaurant.best_dish_id
           dishDetailController.title = restaurant.name
         self.navigationController?.pushViewController(dishDetailController, animated: true)
    }
    
    @IBAction func review(sender: AnyObject?) {
        if AppUtility.isUserLogged(ShowAlert: true) {
            let reviewViewController = storyboard?.instantiateViewControllerWithIdentifier("RestaurantReviewTableViewController") as! RestaurantReviewTableViewController
            reviewViewController.restaurant = restaurant
            let navController = RedNavigationController(rootViewController: reviewViewController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func addRateDish(sender: AnyObject?) {
        if AppUtility.isUserLogged(ShowAlert: true) {
            let rateDishController = self.storyboard?.instantiateViewControllerWithIdentifier("DishRateViewController") as! DishRateViewController
            rateDishController.restaurant = restaurant
            let navController = RedNavigationController(rootViewController: rateDishController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func checkIn(sender: AnyObject?) {
        if AppUtility.isUserLogged(ShowAlert: true) {
            let checkinViewController = storyboard?.instantiateViewControllerWithIdentifier("CheckinViewController") as! CheckinViewController
            checkinViewController.restaurant = restaurant
            let navController = RedNavigationController(rootViewController: checkinViewController)
            self.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    @IBAction func showRestaurantPhotos(sender: AnyObject?) {
        
        if self.restaurant.number_of_photos == 0 {
            self.review(nil)
        }else{
            AppUtility.showActivityOverlay("")
            EatopineAPI.downloadRestaurantPhotos(restaurant.id) { (success, photos) -> () in
                AppUtility.hideActivityOverlay()
                if success {
                    self.restaurantPhotoArray = photos!
                    var basicPhotos = [FSBasicImage]()
                    for photo in photos! {
                        let basicPhoto = FSBasicImage(imageURL: NSURL(string: photo.url)!, authorName: photo.author_display_name, dateCreatedString: AppUtility.reviewCellDateString(photo.createdDate))
                        basicPhotos.append(basicPhoto)
                    }
                    let photoSource = FSBasicImageSource(images: basicPhotos)
                    let imageViewController = FSImageViewerViewController(imageSource: photoSource)
                    imageViewController.title = self.restaurant.name
                    imageViewController.delegate = self
                    (self.tabBarController as! EPTabBarViewController).hideCenterButton()
                    ApplicationDelegate.shouldRotate = true
                    self.navigationController?.pushViewController(imageViewController, animated: true)
                }
            }
        }
        
    }
    
    func imageViewerViewController(imageViewerViewController: FSImageViewerViewController, didReportImageAtIndex index: Int) {
        photoGallerryCurrentIndex = index
        optionsPhoto()
    }
    
    func imageViewerViewController(imageViewerViewController: FSImageViewerViewController, willDismissViewControllerAnimated animated: Bool) {
        ApplicationDelegate.shouldRotate = false
        let value = UIInterfaceOrientation.Portrait.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
    }
    
    @IBAction func showAllDishes(sender: AnyObject?) {
        
        if self.restaurant.number_dishes == 0 {
            addRateDish(nil)
        }else{
            let menuController = storyboard?.instantiateViewControllerWithIdentifier("MenuTableViewController") as! MenuTableViewController
            menuController.restaurant = restaurant
            self.navigationController?.pushViewController(menuController, animated: true)
        }
    }
    
    
    @IBAction func showReview1(sender: AnyObject?) {
        let reviewController = storyboard?.instantiateViewControllerWithIdentifier("ReviewDetailTableViewController") as! ReviewDetailTableViewController
        reviewController.title = restaurant.name
        reviewController.review = reviews[0]
        reviewController.isRestaurantReviewType = true
        self.navigationController?.pushViewController(reviewController, animated: true)
    }
    
    @IBAction func showReview2(sender: AnyObject?) {
        let reviewController = storyboard?.instantiateViewControllerWithIdentifier("ReviewDetailTableViewController") as! ReviewDetailTableViewController
        reviewController.title = restaurant.name
        reviewController.review = reviews[1]
        reviewController.isRestaurantReviewType = true
        self.navigationController?.pushViewController(reviewController, animated: true)
    }
    
    @IBAction func showReviews(sender: AnyObject?) {
        if self.restaurant.number_ratings == 0 {
            review(nil)
        }else{
            let reviewListController = storyboard?.instantiateViewControllerWithIdentifier("ReviewListViewController") as! ReviewListViewController
            reviewListController.title = restaurant.name
            //     reviewListController.reviews = reviews
            reviewListController.restaurant = restaurant
            self.navigationController?.pushViewController(reviewListController, animated: true)
        }
    }
    
    //MARK: - Map
    
    
    
    func addressTapped(sender: UITapGestureRecognizer){
        showDirections()
    }
    
    func showDirections() {
        let mapDirectionsViewController = storyboard?.instantiateViewControllerWithIdentifier("MapDirectionsViewController") as! MapDirectionsViewController
        mapDirectionsViewController.restaurant = restaurant
        self.navigationController?.pushViewController(mapDirectionsViewController, animated: true)
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        let identifier = "RestaurantPin"
        var annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
        if annotationView == nil {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        }
        annotationView!.canShowCallout = false
        annotationView!.image = UIImage(named: "pinRestaurant")
        annotationView!.centerOffset = CGPointMake(0, -annotationView!.image!.size.height / 2);
        
        return annotationView
    }
    
    //MARK: AlertController
    @IBAction func options() {
        
        if AppUtility.isUserLogged(ShowAlert: true) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let saveAction = UIAlertAction(title: "Save to favourites", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                EatopineAPI.saveFavouriteRestaurant(AppUtility.currentUserId.integerValue, restId: self.restaurant.id, completionClosure: { (success) -> () in
                    if success {
                        print("Added to favourites")
                    }
                })
            })
            alertController.addAction(saveAction)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(cancelButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func backToPreviousVC(sender: UIBarButtonItem) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    @IBAction func getDirections(sender: AnyObject) {
        self.navigationController?.popViewControllerAnimated(true)
    }
    //MARK: AlertController
    func optionsPhoto() {
        
        if AppUtility.isUserLogged(ShowAlert: true) {
            let alertController = UIAlertController(title: nil, message: nil, preferredStyle: UIAlertControllerStyle.ActionSheet)
            let saveAction = UIAlertAction(title: "Report photo", style: UIAlertActionStyle.Default, handler: { (alertButton:UIAlertAction) -> Void in
                let photo = self.restaurantPhotoArray[self.photoGallerryCurrentIndex]
                
                EatopineAPI.reportPhoto(photo.id!) { (success) -> () in
                    if success{
                        AppUtility.showAlert("Photo has been reported and will be removed if inappropriate", title: "Success")
                    }
                }
            })
            alertController.addAction(saveAction)
            let cancelButton = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler:nil)
            alertController.addAction(cancelButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    
    @IBAction func openDishes(sender: AnyObject) {
        if self.restaurant.number_dishes == 0 {
            AppUtility.showAlert("No available dishes", title: "Error")
        }else{
            let menuController = storyboard?.instantiateViewControllerWithIdentifier("DishCollectionViewController") as! DishCollectionViewController
            menuController.restaurant = restaurant
            menuController.fromRestaurant = true
            self.navigationController?.pushViewController(menuController, animated: true)
        }
    }
}
