//
//  RestClient.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 18/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
import Alamofire

class RestService {
    
    public static func serviceCall(url:String, method:HTTPMethod, parameters:Parameters?, header:HTTPHeaders?, isLoaded:Bool, title:String, message:String, vc:UIViewController, success: @escaping(Data)->Void, failure:@escaping(Error)->Void){
        
            if isLoaded {
                Indicator.shared().showIndicator(withTitle: title, and: message, vc: vc)
            }
            
            AF.request(url, method: method, parameters: parameters, encoding: JSONEncoding.default, headers: header).responseJSON { (responseData) in
                
                Indicator.shared().hideIndicator(vc: vc)
                
                switch responseData.result{
                case .success(_):
                    success(responseData.data!)
                case .failure(let error):
                    failure(error)
                }
            }
        
    }
}
    
    
    
//    //MARK:- GET API's
//    //MARK:- AuthenticationLogin (GET)
//    public static func authenticateLogin(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description:String, vc:UIViewController, success: @escaping(Data) -> Void, failure: @escaping(Error) -> Void) {
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, headers: header).responseJSON { (responseData) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch responseData.result{
//            case .success(_):
//                success(responseData.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- Login (GET)
//    public static func loginUser(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description:String, vc:UIViewController, success: @escaping(Data) -> Void, failure: @escaping(Error) -> Void) {
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (responseData) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch responseData.result{
//
//            case .success(_):
//                success(responseData.data!)
//            case .failure(let error):
//                failure(error)
//
//            }
//
//        }
//    }
//
//    //MARK:- List all products categories (GET)
//
//    public static func listAllProductCategories(url:String, isLoader: Bool, title: String, description:String, vc:UIViewController, onSuccess success: @escaping ( _ data: [CategoryListAllProducts]) -> Void, onFailure failure: @escaping ( _ error: Error?,  _ params: [AnyHashable: Any]) -> Void) {
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, headers: [.contentType("application/json"), .authorization(username: "ck_3b6eba90048ccd79576fa136cba31c165ba77503", password: "cs_0c60e79fa4bd5f5b54d11e031d56a7077c38ffb2")]).validate().responseJSON(completionHandler: { (responseData) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch(responseData.result){
//            case .success:
//                guard let jsonData = responseData.data, responseData.data != nil else {return}
//
//                do{
//                    let categoriesListAll = try JSONDecoder().decode([CategoryListAllProducts].self, from: jsonData)
//                    success(categoriesListAll)
//                }catch{
//                    print(error.localizedDescription)
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//
//        })
//    }
//
//    //MARK:- all products list based on categories ID (GET)
//
//    public static func allProductListForCategories(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void) {
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, encoding: JSONEncoding.default, headers: [.contentType("application/json"), .authorization(username: "ck_3b6eba90048ccd79576fa136cba31c165ba77503", password: "cs_0c60e79fa4bd5f5b54d11e031d56a7077c38ffb2")]).validate().responseJSON(completionHandler: { (responseData) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch(responseData.result){
//            case .success:
//                success(responseData.data!)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//
//        })
//    }
//
//    //MARK: Customer details by ID (get)
//    public static func CustomerDetailsByID(url:String, isLoader: Bool, title: String, description:String, vc:UIViewController, onSuccess success: @escaping ( _ data: CustomerDetailsID) -> Void, onFailure failure: @escaping ( _ error: Error?,  _ params: [AnyHashable: Any]) -> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url,method: .get, encoding: JSONEncoding.default, headers: [.contentType("application/json"), .authorization(username: "ck_3b6eba90048ccd79576fa136cba31c165ba77503", password: "cs_0c60e79fa4bd5f5b54d11e031d56a7077c38ffb2")]).responseJSON { (customerDetails) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch customerDetails.result {
//            case .success(_):
//
//                guard let customerData = customerDetails.data, customerDetails.data != nil else {return}
//
//                do{
//                    let details = try JSONDecoder().decode(CustomerDetailsID.self, from: customerData)
//                    success(details)
//
//                }catch{
//                    print(error.localizedDescription, "server data")
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//
//    //MARK: Password Reset(GET)
//    public static func passwordReset(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url,method: .get, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (resetPswd) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch resetPswd.result {
//            case .success(_):
//                success(resetPswd.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK:- Liveorders using ID (GET)
//    public static func liveOrderDetails(url: String, method: HTTPMethod, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (liveOrders) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch liveOrders.result{
//            case .success(_):
//                success(liveOrders.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- pastorders using ID (GET)
//    public static func pastOrderDetails(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (pastOrders) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch pastOrders.result{
//            case .success(_):
//                success(pastOrders.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK:- Search API (GET)
//    public static func searchOrderDetails(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, headers: header).responseJSON { (searchDetails) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch searchDetails.result{
//            case .success(_):
//                success(searchDetails.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//
//    //MARK:- Retrive cart Details  (GET)
//    public static func RetrivecartTotalDetails(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (liveOrders) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch liveOrders.result{
//            case .success(_):
//                success(liveOrders.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- RetrivecartDetailsWithproducts  (GET)
//    public static func RetrivecarDetailsWithproducts(url: String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, headers: header).responseJSON { (liveOrders) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch liveOrders.result{
//            case .success(_):
//                success(liveOrders.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- calculationOFcart  (POST)
//    public static func calculationCart(url: String, method:HTTPMethod, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, headers: header).responseJSON { (liveOrders) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch liveOrders.result{
//            case .success(_):
//                success(liveOrders.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//    //MARK:- States List (GET)
//    public static func statesList(url:String, params:Parameters?, header:HTTPHeaders?, isLoader:Bool, title: String, description:String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: header) .responseJSON { (states) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch states.result {
//            case .success(_):
//                success(states.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK:- Shared Key-ID (GET)
//    public static func sharedKey(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (key) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch key.result{
//            case .success(_):
//                success(key.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- Get all wishlist products (GET)
//    public static func allWishlistProducts(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params,encoding: JSONEncoding.default, headers: header).responseJSON { (products) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch products.result{
//            case .success(_):
//                success(products.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//
//    //MARK:- Single product details by product ID (GET)
//    public static func singleProductByProductId(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params,encoding: JSONEncoding.default, headers: header).responseJSON { (products) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch products.result{
//            case .success(_):
//                success(products.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//
//    //MARK:- Bestseller API (GET)
//    public static func bestSellerAPI(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params,encoding: JSONEncoding.default, headers: header).responseJSON { (products) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch products.result{
//            case .success(_):
//                success(products.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//    //MARK:- Pickup address list based on pincode (GET)
//    public static func pickAddrList(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, headers: header).responseJSON { (products) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch products.result{
//            case .success(_):
//                success(products.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//    //MARK: POST API's
//    //MARK:- TimeSLots Cart (Post)
//    public static func timeSlotsCart(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, headers: header).responseJSON { (products) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch products.result{
//            case .success(_):
//                success(products.data!)
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//    //MARK:- productFeedback (Post)
//      public static func productFeedback(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//          if isLoader {
//              Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//          }
//
//          AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (feed) in
//
//              Indicator.shared().hideIndicator(vc: vc)
//
//              switch feed.result {
//              case .success(_):
//                  success(feed.data!)
//              case .failure(let error):
//                  failure(error.localizedDescription as! Error)
//              }
//          }
//      }
//
//    //MARK: SignUp (POST)
//    public static func signUpDetails(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (signUp) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch signUp.result {
//            case .success(_):
//                success(signUp.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//    //send OTP
//    public static func sentOTP(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params,encoding: JSONEncoding.default, headers: header).responseJSON { (otp) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch otp.result{
//            case .success(_):
//                success(otp.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//
//
//
//
//
//    //MARK: Add to cart (post)
//    public static func addToCart(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (signUp) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch signUp.result {
//            case .success(_):
//                success(signUp.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK: cartQuantityChange (POST)
//    public static func cartQuantityChange(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (cart) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch cart.result {
//            case .success(_):
//                success(cart.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//    //MARK: order place before payment Delivery (POST)
//    public static func orderPlaceDelivery(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (cart) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch cart.result {
//            case .success(_):
//                success(cart.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK: order place before payment pickup (POST)
//    public static func orderPlacePickup(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (cart) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch cart.result {
//            case .success(_):
//                success(cart.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK: PUT API's
//    //MARK: order place after payment (PUT)
//    public static func orderPlacePayment(url:String, method:HTTPMethod, params:Parameters?, header:HTTPHeaders?,isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: method, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (cart) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch cart.result {
//            case .success(_):
//                success(cart.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//
//
//    //MARK: update customer Details(PUT)
//    public static func updateProfileDetails(url:String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description: String, vc: UIViewController, success: @escaping(Data)-> Void, failure: @escaping(Error)-> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (updateProfile) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch updateProfile.result {
//            case .success(_):
//                success(updateProfile.data!)
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK: update customer Address (PUT)
//    public static func updateAddress(url:String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc:UIViewController, success: @escaping (Data) -> Void , failure: @escaping (Error) -> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .put, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (addressUpdate) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch addressUpdate.result {
//            case .success(_):
//                success(addressUpdate.data!)
//
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//
//        }
//
//    }
//
//
//    //MARK: Policies, T&C (GET)
//    public static func policiesAPI(url:String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc:UIViewController, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .get, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (addressUpdate) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch addressUpdate.result {
//            case .success(_):
//                success(addressUpdate.data!)
//
//            case .failure(let error):
//                failure(error.localizedDescription as! Error)
//            }
//        }
//    }
//
//    //MARK: Delete item from cart (Delete)
//    public static func removeFromCart(url:String, params: Parameters?, header: HTTPHeaders?, isLoader: Bool, title: String, description:String, vc:UIViewController, success: @escaping (Data) -> Void, failure: @escaping (Error) -> Void){
//
//        if isLoader {
//            Indicator.shared().showIndicator(withTitle: title, and: description, vc: vc)
//        }
//
//        AF.request(url, method: .delete, parameters: params, encoding: JSONEncoding.default, headers: header).responseJSON { (addressUpdate) in
//
//            Indicator.shared().hideIndicator(vc: vc)
//
//            switch addressUpdate.result {
//            case .success(_):
//                success(addressUpdate.data!)
//
//            case .failure(let error):
//                failure(error)
//            }
//        }
//    }
//
//}
