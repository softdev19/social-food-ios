//
//  APIUtility.swift
//  GMO
//
//  Created by Borna Beakovic on 19/09/14.
//  Copyright (c) 2014 GMO. All rights reserved.
//

import UIKit
import MRProgress
import AFNetworking
import Reachability
import SwiftyJSON
import FBSDKLoginKit
import ObjectMapper
import CoreLocation

let EatopineAPI = LibraryAPI.sharedInstance

class LibraryAPI: NSObject {
   
    // closures
    typealias boolClosure = (success: Bool) -> ()
    var hud:MRProgressView?
    
    let persistancyManager = PersistancyManager()
    let restManager = AFHTTPRequestOperationManager()
    let reachability = Reachability(hostName: "google.com")
  //  let lsh = LocalStorageHelper()
    
    class var sharedInstance :LibraryAPI {
    struct Singleton {
        static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    override init() {
        super.init()
        restManager.responseSerializer = EPResponseSerializer()
        setTokenHeader()
    }
    
    
    func saveToken(responseObject:AnyObject) {
        let json = JSON(responseObject)
        if let token = json["token"].string {
            UserDefaults.removeObjectForKey("Token")
            UserDefaults.synchronize()
            UserDefaults.setObject(token, forKey: "Token")
            UserDefaults.synchronize()
            print("new token saved")
        }else{
            print("error saving token")
        }
    }
    
    func setTokenHeader() {
        if (UserDefaults.objectForKey("Token") != nil) {
            let token = UserDefaults.objectForKey("Token") as! String
            print("SETTING TOKEN \(token)")
            restManager.requestSerializer.setValue(token, forHTTPHeaderField: "x-authorization")
        }
    }
    
    func removeTokenHeader() {
        restManager.requestSerializer.setValue("", forHTTPHeaderField: "x-authorization")
        UserDefaults.removeObjectForKey("Token")
        UserDefaults.synchronize()
    }
    
    //MARK: Login methods
    
    
    func login(email:String, password:String, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/login"
        let parameters = ["email":email,"password":password]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("response \(responseObject)")
            
            self.saveToken(responseObject)
            self.setTokenHeader()
            self.persistancyManager.saveUser(responseObject, completionClosure: { (success) -> () in
                completionClosure(success: true)
            })
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func loginFacebook(userProfile:[String:AnyObject], completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/facebook"
        let parameters = ["email":userProfile["email"] as! String,"facebook_id":userProfile["id"] as! String, "facebook_auth":FBSDKAccessToken.currentAccessToken().tokenString, "firstname":userProfile["first_name"] as! String,"lastname":userProfile["last_name"] as! String]
        
        print("Eatopine Facebook Login params: \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("response \(responseObject)")
            
            self.saveToken(responseObject)
            self.setTokenHeader()
            self.persistancyManager.saveUser(responseObject, completionClosure: { (success) -> () in
                completionClosure(success: true)
            })
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    
    func signUp(email:String, password:String,fullName:String, username:String, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/create"
        let parameters = ["email":email,"password":password,"fullname":fullName,"username":username]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("response \(responseObject)")
            
            self.saveToken(responseObject)
            self.persistancyManager.saveUser(responseObject, completionClosure: { (success) -> () in
                completionClosure(success: true)
            })
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func forgotPassword(email:String, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/password"
        let parameters = ["email":email]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("response \(responseObject)")
            completionClosure(success: true)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    
    //MARK: Search methods
    
    
    func searchCity(text:String, completionClosure: ((success: Bool, cities:[CityDetails]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, cities:nil)
            return
        }
        
        let urlString = BaseURL+"/search/city"
        let parameters = ["name":text]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
          //  print("response \(responseObject)")
            
            var cityArray = [CityDetails]()
            
            for dict in responseObject as! [[String:String]]{
                
                let name = dict["city"]
                let state = dict["state"]
                cityArray.append(CityDetails(name: name!, state: state!, lat: 0, lng: 0))
            }
            completionClosure(success: true, cities: cityArray)
            
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, cities:nil)
        }
    }
    
    //MARK: Restaurants
    
    func downloadRestaurantHomePage(completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        
        downloadRestaurantForCity(DefaultCityController.getDefault(), page: 0, price: "", cuisine: "", dish: "", limit: DOWNLOAD_OBJECT_LIMIT, order:"rating_desc", completionClosure: completionClosure)
        
    }
    
    func downloadRestaurantFeed(page: Int, completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants:nil)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/feed"
        let parameters:[String:AnyObject] = ["limit":DOWNLOAD_OBJECT_LIMIT,"page_number":page, "type": 1, "is_user_screen": 0, "friends": 0]
        
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            let array = ModelMapper.mapRestaurantsJSON(responseObject)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, restaurants:nil)
        }
    }
    
    func downloadDishFeed(page: Int, type: Int, userId: Int, userScreen:Bool, friends: Int, completionClosure: ((success: Bool, dishes:[EPDish]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dishes:nil)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/feed"
        var parameters: [String:AnyObject]
        let isUserScreen = userScreen ? 1:0
        if userId == 0 {
            parameters = ["limit":DOWNLOAD_OBJECT_LIMIT,"page_number":page, "type": type, "is_user_screen": isUserScreen, "friends": friends]
        }
        else {
            parameters = ["limit":DOWNLOAD_OBJECT_LIMIT,"page_number":page, "type": type, "is_user_screen": isUserScreen, "friends": friends , "user_id": userId]
        }
        
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            let array = ModelMapper.mapDishesJSON(responseObject)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, dishes:nil)
        }
    }
    
    func downloadRestaurantForCity(city:CityDetails, page:Int, price:String, cuisine:String,dish:String, limit:Int, order:String, completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants:nil)
            return
        }
        
        let urlString = BaseURL+"/restaurant/list"
        var parameters:[String:AnyObject] = ["limit":limit,"price":price, "cuisine":cuisine, "dish":dish, "order":order]
        
        if city.name.characters.count > 0 && city.state.characters.count > 0 {
            parameters["city"] = city.name
            parameters["state"] = city.state
        }
        parameters["page_number"] = page
        
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        //    print("downloaded restaurants \(responseObject)")
            let array = ModelMapper.mapRestaurantsJSON(responseObject)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, restaurants:nil)
        }
    }
    
    func downloadRestaurantAroundUserLocation(userLocation:CLLocation, price:[String], cuisine:String,dish:String, completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants:nil)
            return
        }
        
        let urlString = BaseURL + "/restaurant/list"//"/restaurant/map"
        let parameters = ["limit":500 as AnyObject, "latitude":userLocation.coordinate.latitude,"longitude":userLocation.coordinate.longitude, "price":price, "cuisine":cuisine, "dish":dish]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
         //   print("NEARBY restaurants \(responseObject)")
            
            let array = ModelMapper.mapRestaurantsJSON(responseObject)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, restaurants:nil)
        }
    }
    
    func downloadRestaurantByString(searchString:String, userLocation: CLLocation, searchType: String, completionClosure:((success: Bool, restaurants:[EPRestaurant]?) ->() )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants: nil)
            return
        }
        
        let urlString = BaseURL + "/restaurant/map"
        var params:[String: AnyObject] = ["latitude": userLocation.coordinate.latitude, "longitude": userLocation.coordinate.longitude]
        if (searchString != "") {
            params["search_text"] = searchString
            params["search_type"] = searchType
        }
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            let array = ModelMapper.mapRestaurantsJSON(responseObject)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, restaurants:nil)
        }
    }

    func searchRestaurants(searchString:String, completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants:nil)
            return
        }
        
        var location = LocationManager.userLocation
        if location == nil {
            let city = DefaultCityController.getDefault()
            location = CLLocation(latitude: CLLocationDegrees(city.latitude), longitude: CLLocationDegrees(city.longitude))
        }
        
        let urlString = BaseURL+"/search/restaurant"
        let parameters = ["name":searchString,"latitude":location!.coordinate.latitude,"longitude":location!.coordinate.longitude]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
             //  print("downloaded dishes \(responseObject)")
            
            let array = ModelMapper.mapRestaurantsJSON(responseObject)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, restaurants:nil)
        }
    }
    
    func downloadRestaurantPhotos(restId:Int, completionClosure: ((success: Bool, photos:[EPPhoto]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, photos:nil)
            return
        }
        
        let urlString = BaseURL+"/restaurant/getPhotos"
        let parameters = ["limit":1000,"page_number":1,"rest_id":restId]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
              print("RESTAURANT PHOTOS \(responseObject)")
            
            let array = Mapper<EPPhoto>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, photos: array!)
            }else{
                completionClosure(success: false, photos: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, photos:nil)
        }
    }
    
    
    func downloadRestaurantInfo(restaurantId:Int, completionClosure: ((success: Bool, info:EPRestaurantInfo?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, info:nil)
            return
        }
        
        let urlString = BaseURL+"/restaurant/getInfo"
        let parameters = ["id":restaurantId as AnyObject]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            completionClosure(success: true, info: ModelMapper.mapRestaurantInfoJSON(responseObject))
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, info:nil)
        }
    }
    
    func downloadRestaurantHours(restaurantId:Int, completionClosure: ((success: Bool, hours:EPRestaurantHours?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, hours:nil)
            return
        }
        
        let urlString = BaseURL+"/restaurant/getHours"
        let parameters = ["id":703 as AnyObject, "today":""]
    //    print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            
            completionClosure(success: true, hours: EPRestaurantHours(hoursJSON: responseObject))
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, hours:nil)
        }
    }
    
    func downloadRestaurantPage(restaurantId:Int, completionClosure: ((success: Bool, restaurant:EPRestaurant?) -> () )) {
        if isInternetConnectionNotActive() || restaurantId == 0 {
            completionClosure(success: false, restaurant:nil)
            return
        }
        
        let urlString = BaseURL + "/restaurant/restPage"
        let parameters = ["id":restaurantId]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
               print("restaurant \(responseObject)")
            let mapped = ModelMapper.mapSingledRestaurantJSON(responseObject)
            
            completionClosure(success: true, restaurant: mapped)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, restaurant:nil)
        }
    }
    
    func downloadRestaurant(restaurantId:Int, completionClosure: ((success: Bool, restaurant:EPRestaurant?) -> () )) {
        if isInternetConnectionNotActive() || restaurantId == 0 {
            completionClosure(success: false, restaurant:nil)
            return
        }
        
        let urlString = BaseURL+"/restaurant/getById"
        let parameters = ["id":restaurantId]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
        //    print("restaurant \(responseObject)")
            let mapped = ModelMapper.mapSingledRestaurantJSON(responseObject)
            
            completionClosure(success: true, restaurant: mapped)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, restaurant:nil)
        }
    }
    
    func downloadDishComments(ratingId: Int, limit: Int, completionClosure: ((success: Bool, comments:[Comment]?) -> () )) {
        if isInternetConnectionNotActive() || ratingId == 0 {
            completionClosure(success: false, comments:nil)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/getComments"
        let parameters = ["rating_id":ratingId, "limit":limit]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("Restaurant Reviews \(responseObject)")
            
            let array = Mapper<Comment>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, comments: array)
            }else{
                completionClosure(success: false, comments: nil)
            }
            
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, comments:nil)
        }
    }
    
    func downloadRestaurantReviews(restaurantId:Int, page:Int, downloadLimit:Int, order:String,  completionClosure: ((success: Bool, reviews:[EPReview]?) -> () )) {
        if isInternetConnectionNotActive() || restaurantId == 0 {
            completionClosure(success: false, reviews:nil)
            return
        }
        
        let urlString = BaseURL + "/restaurant/getReviews"
        let parameters = ["rest_id":restaurantId, "page_number":page, "limit":downloadLimit, "order":order]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
               print("Restaurant Reviews \(responseObject)")
            
            let array = Mapper<EPReview>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, reviews: array)
            }else{
                completionClosure(success: false, reviews: nil)
            }
            
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, reviews:nil)
        }
    }
    
    func reviewRestaurant(restaurantId:Int,reviewText:String,rating:Int, photos:[UIImage], completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/restaurant/rate"
        let parameters = ["rest_id":restaurantId as AnyObject, "user_id":AppUtility.currentUserId,"rating":rating,"description":reviewText]
        
        print("params \(parameters)")
        restManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            
            for (index,photo) in photos.enumerate() {
                let photoData = UIImageJPEGRepresentation(photo, 0.8)
                if photoData != nil {
                    formData.appendPartWithFileData(photoData!, name: "photo[]", fileName: "photo\(index)", mimeType: "image/jpeg")
                }
            }
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                print("respon \(responseObject)")
                let message = responseObject["message"] as! String
                if message == "success"{
                    completionClosure(success: true)
                }else{
                    completionClosure(success: false)
                }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("respon \(operation.responseObject)")
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func checkinToRestaurant(restaurantId:Int,text:String, photo:UIImage?, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/restaurant/checkIn"
        let parameters = ["rest_id":restaurantId as AnyObject, "user_id":AppUtility.currentUserId,"text":text]
        
        print("params \(parameters)")
        restManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            
            if photo != nil {
                let photoData = UIImageJPEGRepresentation(photo!, 0.8)
                formData.appendPartWithFileData(photoData!, name: "photo", fileName: "photo", mimeType: "image/jpeg")
            }
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                if let code = responseObject["0"] as? Int {
                    if code == 400 {
                        self.invalidTokenHandler(responseObject)
                        return
                    }
                }
                
                print("response \(responseObject)")
                let message = responseObject["message"] as! String
                if message == "success"{
                    completionClosure(success: true)
                }else{
                    completionClosure(success: false)
                }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    //MARK: Dishes
    
    func downloadDishesForCity(city:CityDetails, page:Int, completionClosure: ((success: Bool, dishes:[EPDish]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dishes:nil)
            return
        }
        
        let urlString = BaseURL+"/dish/list"
        var parameters = ["limit":25 as AnyObject]
        
        if city.latitude > 0 && city.longitude > 0 {
            parameters["latitude"] = city.latitude
            parameters["longitude"] = city.longitude
            parameters["order"] = "rating_desc"
        }
        if city.name.characters.count > 0 && city.state.characters.count > 0 {
            parameters["city"] = city.name
            parameters["state"] = city.state
        }
        parameters["page_number"] = page
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
         //   print("downloaded dishes \(responseObject)")
            
            let array = Mapper<EPDish>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, dishes:nil)
        }
    }
    
    func searchDishes(searchString:String, completionClosure: ((success: Bool, dishes:[EPDish]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dishes:nil)
            return
        }
        
        var location = LocationManager.userLocation
        if location == nil {
            let city = DefaultCityController.getDefault()
            location = CLLocation(latitude: CLLocationDegrees(city.latitude), longitude: CLLocationDegrees(city.longitude))
        }
        
        let urlString = BaseURL+"/search/dish"
        let parameters = ["name":searchString,"latitude":location!.coordinate.latitude,"longitude":location!.coordinate.longitude]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            //   print("downloaded dishes \(responseObject)")
            
            let array = Mapper<EPDish>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, dishes:nil)
        }
    }
    
    //MARK: Download Dish for Search
    func downloadDishInSearch(userLocation: CLLocation, order: String, price: String, vote: String, type : String, pageNum: Int, completionClosure:((success: Bool, dishes: [EPSearchDish]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dishes: nil)
            return
        }
        
        let urlString = BaseURL + "/dish/list"
        let params:[String: AnyObject] = ["latitude": userLocation.coordinate.latitude, "longitude": userLocation.coordinate.longitude, "order": order, "vote": vote, "limit": 25, "page_number": pageNum]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("downloaded dishes \(responseObject)")
            
            let array = Mapper<EPSearchDish>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, dishes:nil)
        }
    }
    
    //MARK : Download Dish for a Restaurant
    func downloadDish(dishId:Int, completionClosure: ((success: Bool, dish:EPMapDish?) -> () )) {
        if isInternetConnectionNotActive() || dishId == 0 {
            completionClosure(success: false, dish:nil)
            return
        }
        
        let urlString = BaseURL+"/dish/byId"
        let parameters = ["id":dishId]
          print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("dish \(responseObject)")
            let mappedDish = ModelMapper.mapSingleMapDishJSON(responseObject)
            
            completionClosure(success: true, dish: mappedDish)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, dish:nil)
        }
    }
    
    func downloadRestaurantDishes(restaurantId:Int, page:Int, completionClosure: ((success: Bool, dishes:[EPResDish]?) -> () )) {
        if isInternetConnectionNotActive() || restaurantId == 0 {
            completionClosure(success: false, dishes:nil)
            return
        }
        
        let urlString = BaseURL+"/dish/byRestaurant"
        let parameters = ["rest_id":restaurantId, "limit":30, "page_number":page]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("Restaurant Dishes \(responseObject)")
            
            let array = Mapper<EPResDish>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, dishes:nil)
        }
    }
    
    func rateDish(dishId:Int,reviewText:String,rating:Int, photos:[UIImage], completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/dish/rate"
        let parameters = ["dish_id":dishId as AnyObject, "user_id":AppUtility.currentUserId,"rating":rating,"description":reviewText]
        
        print("params \(parameters)")
        restManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            
            for (index,photo) in photos.enumerate() {
                let photoData = UIImageJPEGRepresentation(photo, 0.8)
                formData.appendPartWithFileData(photoData!, name: "photo[]", fileName: "photo\(index)", mimeType: "image/jpeg")
            }
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                
                let message = responseObject["message"] as! String
                if message == "Success"{
                    completionClosure(success: true)
                }else{
                    completionClosure(success: false)
                }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func addDish(restId:Int, dishName:String, reviewText:String,rating:Int, course:Int, photos:[UIImage], completionClosure: ((success: Bool, dish_id:Int) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dish_id:0)
            return
        }
        
        let urlString = BaseURL+"/dish/add"
        var parameters = ["user_id":AppUtility.currentUserId, "rest_id":restId,"rating":rating,"description":reviewText, "name":dishName]
        if course != 0 {
            parameters["course"] = course
        }
        
        print("params \(parameters)")
        restManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            
            for (index,photo) in photos.enumerate() {
                let photoData = UIImageJPEGRepresentation(photo, 0.8)
                formData.appendPartWithFileData(photoData!, name: "photo[]", fileName: "photo\(index)", mimeType: "image/jpeg")
            }
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                print("resposne \(responseObject)")
                let json = JSON(responseObject)
                
                let message = responseObject["message"] as! String
                let numberFormatter = NSNumberFormatter()
                let dishId = numberFormatter.numberFromString(json["dish_id"].string!)
                if message == "Success"{
                    completionClosure(success: true, dish_id:(dishId?.integerValue)!)
                }else{
                    completionClosure(success: false, dish_id:(dishId?.integerValue)!)
                }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("resposne \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, dish_id:0)
        }
    }
    
    func downloadDishReviews(dishId:Int, completionClosure: ((success: Bool, reviews:[EPReview]?) -> () )) {
        if isInternetConnectionNotActive() || dishId == 0 {
            completionClosure(success: false, reviews:nil)
            return
        }
        
        let urlString = BaseURL+"/dish/getReviews"
        let parameters = ["dish_id":dishId, "page_number":1]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            //   print("Restaurant Dishes \(responseObject)")
            
            let array = Mapper<EPReview>().mapArray(responseObject)
            if array != nil {
                completionClosure(success: true, reviews: array!)
            }else{
                completionClosure(success: false, reviews: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, reviews:nil)
        }
    }
    
    func downloadSingleReview(reviewId:Int,isRestaurantReviewType:Bool, completionClosure: ((success: Bool, review:EPReview?) -> () )) {
        if isInternetConnectionNotActive(){
            completionClosure(success: false, review:nil)
            return
        }
        
        var urlString = ""
        if isRestaurantReviewType == true {
            urlString = BaseURL+"/restaurant/getReview"
        }else{
            urlString = BaseURL+"/dish/getReview"
        }
        
        let parameters = ["id":reviewId]
        print("params \(parameters)")
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
               print("Single dish: \(responseObject)")
            completionClosure(success: true, review: Mapper<EPReview>().map(responseObject))
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, review:nil)
        }
    }
    
    //MARK: Dish Like/Dislike
    
    func likeDish(ratingId:Int, userId:Int, fromDev:Int, liked:Bool, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        var urlString = ""
        if (liked) {
            urlString = BaseURL + "/dish-rating/addLike"
        }
        else {
            urlString = BaseURL + "/dish-rating/deleteLike"
        }
        let parameters = ["rating_id":ratingId, "user_id":userId, "fromDev":fromDev]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            completionClosure(success: true)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false)
        }
    }

    //MARK: Dish Liked User List
    
    func getLikes(ratingId:Int, userId:Int, pageNumber:Int, limit:Int, completionClosure: ((success: Bool, users:[LikeUser]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, users: nil)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/getLikes"
        
        var parameters:[String:AnyObject]
        if (userId == 0) {
            parameters = ["rating_id":ratingId as AnyObject, "page_number":pageNumber as AnyObject, "limit":limit as AnyObject]
        }
        else {
            parameters = ["rating_id":ratingId as AnyObject, "user_id":userId as AnyObject, "page_number":pageNumber as AnyObject, "limit":limit as AnyObject]
        }
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            let array = ModelMapper.mapUsersJSON(responseObject)
            
            completionClosure(success: true, users: array)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, users:nil)
        }
    }
    
    
    //Mark: Add Comment
    func addComment(ratingId:Int, userId:Int, text:String, country:String, fromDev:Int, completionClosure:((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/addComment"
        let parameters = ["rating_id":ratingId, "user_id":userId, "text":text, "country":country]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print(responseObject)
            completionClosure(success: true)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false)
        }
    }

    //MARK: Cuisine methods
    
    func getCuisines(completionClosure: ((success: Bool, cuisine:[EPCuisine]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, cuisine:nil)
            return
        }
        
        let urlString = BaseURL+"/search/cuisines"

        restManager.POST(urlString, parameters: nil, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            let array = ModelMapper.mapCuisineJSON(responseObject)
            
            completionClosure(success: true, cuisine: array)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false, cuisine:nil)
        }
    }
    
    //MARK: User methods
    
    func downloadUser(userId:Int, completionClosure: ((success: Bool, userObject:UserProfile?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false,userObject:nil)
            return
        }
        
        let urlString = BaseURL+"/user/getById"
        let parameters = ["user_id":userId]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("response \(responseObject)")
            completionClosure(success: true, userObject: Mapper<UserProfile>().map(responseObject!))
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false,userObject:nil)
        }
    }
    
    func downloadUserActivity(userId:Int, pageNumber:Int, limit:Int, completionClosure: ((success: Bool, actions:[EPActivity]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false,actions:nil)
            return
        }
        
        let urlString = BaseURL+"/user/activities"
        let parameters = ["user_id":userId, "limit":limit,"page_number":pageNumber]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("ACTIONS response \(responseObject)")
            
            let array = Mapper<EPActivity>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, actions: array!)
            }else{
                completionClosure(success: false, actions: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false,actions:nil)
        }
    }
    
    func downloadUserSavedRes(userId: Int, limit: Int, pageNum: Int, completionClosure: ((success: Bool, restaurants: [EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants: nil)
            return
        }
        
        let urlString = BaseURL + "/user/savedRest"
        let param = ["user_id": userId, "limit": limit, "page_number": pageNum]
        
        restManager.POST(urlString, parameters: param, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("ACTIONS response \(responseObject)")
            
            let array = Mapper<EPRestaurant>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false,restaurants: nil)
        }
    }
    func updateUser(userId:Int, fullName:String, userName: String, city:String, description: String, email: String, telephone: String, gender: String, photo:UIImage?, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/update"
        let parameters:[String:AnyObject] = ["user_id":userId, "email":email, "full_name":fullName, "username":userName, "city":city, "about_you":description, "telephone":telephone, "gender":gender]
        print("id \(parameters)")
        restManager.POST(urlString, parameters: parameters, constructingBodyWithBlock: { (formData:AFMultipartFormData!) -> Void in
            
            if photo != nil {
                let photoData = UIImageJPEGRepresentation(photo!, 0.5)
                formData.appendPartWithFileData(photoData!, name: "photo", fileName: "photo\(userId)", mimeType: "image/jpeg")
            }
            
            }, success: { (operation:AFHTTPRequestOperation!, responseObject:AnyObject!) -> Void in
                print("res \(responseObject)")
                if let code = responseObject["0"] as? Int {
                    if code == 400 {
                        self.invalidTokenHandler(responseObject)
                        return
                    }
                }
                
                let message = responseObject["message"] as! String
                if message == "success"{
                    completionClosure(success: true)
                }else{
                    completionClosure(success: false)
                }
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func removeUserProfilePhoto(userId:Int, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/user/removeImage"
        let parameters = ["user_id":userId]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("REMOVE image response \(responseObject)")
            
            completionClosure(success: true)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func report(id: Int, type: String, reason: String, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/report"
        let parameters = ["id": id, "type": type, "reason": reason]
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("REPORT image response \(responseObject)")
            if let code = responseObject["0"] as? Int {
                if code == 400 {
                    self.invalidTokenHandler(responseObject)
                    return
                }
            }
            
            let message = responseObject["message"] as! String
            if message == "success"{
                completionClosure(success: true)
            }else{
                completionClosure(success: false)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false)
        }
    }

    
    func reportPhoto(photoId:Int, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/report/photo"
        let parameters = ["photo_id":photoId]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("REPORT image response \(responseObject)")
            if let code = responseObject["0"] as? Int {
                if code == 400 {
                    self.invalidTokenHandler(responseObject)
                    return
                }
            }
            
            let message = responseObject["message"] as! String
            if message == "success"{
                completionClosure(success: true)
            }else{
                completionClosure(success: false)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func removeProfileImg(userId: Int, completionClourse: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClourse(success: false)
            return
        }
        
        let urlString = BaseURL + "/user/removeImage"
        let params = ["user_id": userId]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Update Pass : \(responseObject)")
            completionClourse(success: true)
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClourse(success: false)
        }
    }
    
    //MARK: Update Password
    func updatePassword(userId: Int, currentPass: String, newPass: String, completionClourse: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClourse(success: false)
            return
        }
        
        let urlString = BaseURL + "/user/updatePassword"
        let params = ["user_id": userId, "current_password": currentPass, "new_password": newPass]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Update Pass : \(responseObject)")
            completionClourse(success: true)
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClourse(success: false)
        }
    }
    
    //MARK: Report Contact
    func supportReport(userId: Int, report: String, completionClourse: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClourse(success: false)
            return
        }
        
        let urlString = BaseURL + "/report/contact"
        let params = ["user_id": userId, "text": report]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("report contact : \(responseObject)")
            completionClourse(success: true)
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClourse(success: false)
        }
    }
    
    func saveFavouriteRestaurant(userId:Int, restId:Int, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        let urlString = BaseURL+"/restaurant/saveFavorite"
        let parameters = ["user_id":userId,"rest_id":restId]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("SAVED response \(responseObject)")
            completionClosure(success: true)
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false)
        }
    }
    
    func getFavouriteRestaurant(userId:Int, completionClosure: ((success: Bool, favourites:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false,favourites:nil)
            return
        }
        
        let urlString = BaseURL+"/user/savedRest"
        let parameters = ["user_id":userId, "limit":500]
        print("param \(parameters)")
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) -> Void in
            print("FAVOURITE RESTAURANTS response \(responseObject)")
            
            let array = Mapper<EPRestaurant>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, favourites: array!)
            }else{
                completionClosure(success: false, favourites: nil)
            }
            
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) -> Void in
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClosure(success: false,favourites:nil)
        }
    }
    
    func invalidTokenHandler(response:AnyObject){
        let json = JSON(response)
        let error = json["error"]
        AppUtility.logout()
        AppUtility.showAlert(error["description"].string!, title: error["message"].string!)
    }
    
    //MARK: Follow / Unfollow
    func followUser(userId:Int, followId:Int, fromDev:Int, liked:Bool, completionClosure: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false)
            return
        }
        
        var urlString = ""
        if (liked) {
            urlString = BaseURL + "/user/follow"
        }
        else {
            urlString = BaseURL + "/user/unfollow"
        }
        let parameters = ["user_id":userId, "followed_id":followId, "fromDev":fromDev]
        
        restManager.POST(urlString, parameters: parameters, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            completionClosure(success: true)
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false)
        }
    }
    
    //MARK: Get Restaurant
    func getRestaurant(params: [String:AnyObject], completionClosure: ((success: Bool, restaurants:[EPRestaurant]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restaurants: nil)
            return
        }
        
        let urlString = BaseURL + "/search/restaurant"
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            let array = Mapper<EPRestaurant>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, restaurants: array!)
            }else{
                completionClosure(success: false, restaurants: nil)
            }

        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, restaurants: nil)
        }

    }
    
    //MARK: Create Restaurant
    func createRestaurant(name: String, address: String, city: String, country: String, userId: Int, state: String, completionClosure: ((success: Bool, restId: String) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, restId: "")
            return
        }
        
        let urlString = BaseURL + "/restaurant/create"
        
        let parameter : [String: AnyObject] = ["name": name, "address": address, "city": city, "country": country, "user_id": userId]
        
        restManager.POST(urlString, parameters: parameter, success: { (operation: AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Add Restaurant: \(responseObject)")
            let json = JSON(responseObject)
            if let restId = json["rest_id"].string {
                completionClosure(success: false, restId: restId)
            }
        }) { (operation: AFHTTPRequestOperation!, error: NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, restId: "")
        }
    }
    
    //MARK: Search Dish
    func getDish(params: [String: AnyObject], completionClosure: ((success: Bool, dishes:[EPDish]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, dishes: nil)
            return
        }
        
        let urlString = BaseURL + "/search/dish"

        print(params)
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            let array = Mapper<EPDish>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, dishes: array!)
            }else{
                completionClosure(success: false, dishes: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, dishes: nil)
        }
    }
    
    //MARK: Add Rating
    func addRating(dict: [String: AnyObject], image: UIImage, completionClourse: ((success: Bool) -> () )) {
        if isInternetConnectionNotActive() {
            completionClourse(success: false)
            return
        }
        
        let urlString = BaseURL + "/dish-rating/addRate"
        let imagedata = UIImageJPEGRepresentation(image, 0.5)

        restManager.POST(urlString, parameters: dict, constructingBodyWithBlock: { (formData: AFMultipartFormData!) in
            formData.appendPartWithFileData(imagedata!, name: "Photo", fileName: "photo\(dict["dish_id"])", mimeType: "image/jpeg")
            }, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
                print("Dish Like : \(responseObject)")
                completionClourse(success: true)
            }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
                print("error \(operation.responseObject)")
                
                if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                    AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
                }else{
                    AppUtility.showAlert(error.localizedDescription, title: "Error")
                }
                completionClourse(success: false)
        }
    }
    
    func getFollowers(userId: Int, limit: Int, completionClosure: ((success: Bool, users:[LikeUser]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, users: nil)
            return
        }
        
        let urlString = BaseURL + "/user/getFollowers"
        let params = ["user_id": userId, "limit": limit, "page_number": 0]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            let array = Mapper<LikeUser>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, users: array!)
            }else{
                completionClosure(success: false, users: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, users: nil)
        }

    }

    func getFollowing(userId: Int, limit: Int, completionClosure: ((success: Bool, users:[LikeUser]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, users: nil)
            return
        }
        
        let urlString = BaseURL + "/user/getFollowing"
        let params = ["user_id": userId, "limit": limit, "page_number": 0]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            let array = Mapper<LikeUser>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, users: array!)
            }else{
                completionClosure(success: false, users: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, users: nil)
        }
        
    }

    func searchUsers(searchStr: String, completionClosure: ((success: Bool, users: [LikeUser]?) -> () )) {
        if isInternetConnectionNotActive() {
            completionClosure(success: false, users: nil)
            return
        }
        
        let urlString = BaseURL + "/search/user"
        let params = ["name": searchStr]
        
        restManager.POST(urlString, parameters: params, success: { (operation:AFHTTPRequestOperation!, responseObject: AnyObject!) in
            print("Dish Like : \(responseObject)")
            let array = Mapper<LikeUser>().mapArray(responseObject!)
            if array != nil {
                completionClosure(success: true, users: array!)
            }else{
                completionClosure(success: false, users: nil)
            }
            
        }) { (operation:AFHTTPRequestOperation!, error:NSError!) in
            print("error \(operation.responseObject)")
            
            if let epError = error.userInfo[EPErrorResponseKey] as? EPError {
                AppUtility.showAlert(epError.errorDescription, title: epError.errorMessage)
            }else{
                AppUtility.showAlert(error.localizedDescription, title: "Error")
            }
            completionClosure(success: false, users: nil)
        }

    }
    
    func isInternetConnectionNotActive() -> Bool {
        let networkStatus = reachability.currentReachabilityStatus()
        
        if networkStatus == NetworkStatus.NotReachable{
            AppUtility.showAlert("Please check your internet connection and try again.", title: "No Internet connection")
            return true
        }else{
            return false
        }
    }

    func parseJSON(inputData: NSData) -> NSDictionary?{
        do{
            let json = try NSJSONSerialization.JSONObjectWithData(inputData, options: NSJSONReadingOptions()) as? NSDictionary
            return json
        } catch  let error as NSError{
            print(error)
            return nil
        }
    }
    
}



