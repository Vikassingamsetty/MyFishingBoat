//
//  HomeViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps
import GooglePlaces
import Kingfisher

struct Welcome: Codable {
    //let page, perPage, total, totalPages: Int
    let data: [DataDetails]
    //let support: Support

//    enum CodingKeys: String, CodingKey {
//        case page
//        case perPage = "per_page"
//        case total
//        case totalPages = "total_pages"
//        case data, support
//    }
}

// MARK: - Datum
struct DataDetails: Codable {
    let id: Int
    let email, firstName, lastName: String
    let avatar: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}

// MARK: - Support
//struct Support: Codable {
//    let url: String
//    let text: String
//}

class HomeSingleton {
    private init() {}
    static let shared = HomeSingleton()
    
    var id: [Int]?
    var email: [String]?
    var lastName: [String]?
    var firstName: [String]?
    var image: [String]?
}

class HomeViewController: BaseViewController {
    
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var scrollItemsCollectionView: UICollectionView! //1
    @IBOutlet weak var sliderCollectionView: UICollectionView! //2
    @IBOutlet weak var categoryCollectionView: UICollectionView! //3
    @IBOutlet weak var bestSellersCollectionView: UICollectionView! //4
    @IBOutlet weak var pageView: UIPageControl!
    @IBOutlet weak var notificationOrSearchBtn: UIButton!
    @IBOutlet weak var UserCitylocationlbl: UILabel!
    
    var locManager = CLLocationManager()
    var lattitude : Double!
    var longitude : Double!
    
    var imgArr = Int()
    
    var scrollImageArr = [UIImage(named: "Group 221"),UIImage(named:"Path 596"), UIImage(named: "Group 224"), UIImage(named: "Group 223"), UIImage(named: "Group 225"), UIImage(named: "Marinated")]
    
    var namesArr = ["Fresh Water", "Sea Water", "Shell Fish", "Dry Fish", "Pickels", "Marinated"]
    var IdArr = [68,69,84,70,71,72]
    
    var timer = Timer()
    var counter = 0
    
    var locationDetails = String()
    
    //Model declarations
    var categoryStaticList:CategoryStaticList?
    var listAllProductCategory:CategoryListAllProducts?
    var bestSeller: BestSellerModel?
    var addToCartBtnModel:AddToCartBtnModel?
    var autoImgScrollModel:AutoImgScrollModel?
    
    //min and max quantity change
    var quantity = Int()
    var price = String()
    
    //addcart btn dict
    var addCart = [Int:Int]()
    
    //Coredata Array
    var prdtListArray: [NSManagedObject] = []
    var indexLits: [NSManagedObject] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        vikasAPI()
        
        //Menu button
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        //Network connectivity to load API's
        if Reachability.isConnectedToNetwork() {
            
            userCategoryList()
            userImagesAutoScroll()
            userStaticCategoryList()
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
                userBestSellerList(uid: uid)
                
            }else{
                userBestSellerList(uid: "")
            }
        }else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    var welcome: Welcome?
    
    //MARK:-TODO
    func vikasAPI() {
        RestService.serviceCall(url: "https://reqres.in/api/users?page=1", method: .get, parameters: nil, header: [.contentType("application/json")], isLoaded: true, title: "", message: "Loading...", vc: self) { [weak self] response in
            
            guard let responseJson = try? JSONDecoder().decode(Welcome.self, from: response) else {return}
            
            if responseJson.data.count > 0 {
                self?.welcome = responseJson
                self?.setupVikas()
            }
            
        } failure: { error in
            showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
        }
        
    }
    
    func setupVikas() {
        HomeSingleton.shared.id = welcome?.data.map{$0.id}
        HomeSingleton.shared.email = welcome?.data.map{$0.email}
        HomeSingleton.shared.firstName = welcome?.data.map{$0.firstName}
        HomeSingleton.shared.lastName = welcome?.data.map{$0.lastName}
        HomeSingleton.shared.image = welcome?.data.map{$0.avatar}
        
        print(HomeSingleton.shared.image?[0] ?? "")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        self.tabBarController?.tabBar.isHidden = false // tabBarController exists
        
        if Reachability.isConnectedToNetwork() {
            
            userCategoryList()
            userImagesAutoScroll()
            userStaticCategoryList()
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
                userBestSellerList(uid: uid)
                cartTotal()
                userWishList(uid: uid)
            }else{
                //self.tabBarController?.tabBar.items?[2].badgeValue = "0"
                fetchRequestResult()
                userBestSellerList(uid: "")
            }
        }else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        //image slides auto scroll
        self.pageView.currentPage = 0
        
        geoCoding()
    }
    
    func geoCoding() {
        
        self.tabBarController?.tabBar.isHidden = false // tabBarController exists
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
                
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                
                let alert = UIAlertController(title: "Alert", message: "Please enable your location", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                     //self.geoCoding()
                    
                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    //UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)

                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                    guard let currentLocation = locManager.location else {
                        return
                    }
                    
                    lattitude = currentLocation.coordinate.latitude
                    longitude = currentLocation.coordinate.longitude
                    
                    if lattitude != 0.0 {
                        let location1 = CLLocation(latitude: lattitude, longitude: longitude)
                        
                        CLGeocoder().reverseGeocodeLocation(location1) { placemarks, error in
                            
                            guard let placemark = placemarks?.first else {
                                let errorString = error?.localizedDescription ?? "Unexpected Error"
                                print("Unable to reverse geocode the given location. Error: \(errorString)")
                                return
                            }
                            
                            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                            print(reversedGeoLocation.streetName)
                            print(reversedGeoLocation.zipCode)
                            print(reversedGeoLocation.city)
                            print(reversedGeoLocation.country)
                            print(reversedGeoLocation.name)
                            let city = "\(reversedGeoLocation.name+" "+reversedGeoLocation.city)"
                            self.UserCitylocationlbl.text = city
                            UserDefaults.standard.set(city, forKey: "city")
                            print(city)
                            
                        }
                    }
                }
            default:
                print("error in location home screen")
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    //Don't delete it
    @IBAction func backToHome(_ sender: UIStoryboardSegue){}
    
    @objc func changeImage() {
        
        if counter < imgArr {
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageView.currentPage = counter
            counter += 1
        } else {
            counter = 0
            let index = IndexPath.init(item: counter, section: 0)
            self.sliderCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageView.currentPage = counter
            counter = 1
        }
    }
    
    //MARK:- API calls
    //Auto Images scroll
    func userImagesAutoScroll(){
        
        RestService.serviceCall(url: imageSlidesAuto_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self) {[weak self] (response) in
            guard let self = self else {return}
            guard let responseJson = try? JSONDecoder().decode(AutoImgScrollModel.self, from: response) else{return}
            self.autoImgScrollModel = responseJson
            if responseJson.status == 200 {
                print(self.autoImgScrollModel?.data?.count, "scroll images count")
                
                DispatchQueue.main.async {
                    
                    //Paging of images
                    self.imgArr = self.autoImgScrollModel?.data?.count ?? 0
                    self.pageView.numberOfPages = self.autoImgScrollModel?.data?.count ?? 0
                    self.sliderCollectionView.reloadData()
                    self.timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        } failure: { (error) in
            showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
        }
    }
    
    //Static Category list
    func userStaticCategoryList() {
        
        RestService.serviceCall(url: staticCategoryList_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CategoryStaticList.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.categoryStaticList = responseJson
                print(responseJson.data?.count)
                
                DispatchQueue.main.async {
                    self.scrollItemsCollectionView.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //list all product category
    func userCategoryList() {
        
        RestService.serviceCall(url: categorylist_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CategoryListAllProducts.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.listAllProductCategory = responseJson
                print(responseJson.data?.count)
                
                DispatchQueue.main.async {
                    self.categoryCollectionView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
    //Best seller API
    func userBestSellerList(uid:String) {
        
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: bestseller_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(BestSellerModel.self, from: response) else{return}
            self.bestSeller = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.bestSellersCollectionView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.bestSeller!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Loading...", messageStr: error.localizedDescription)
        }
        
    }
    
    //cart total and list
    func cartTotal() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: cartList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do {
                let responseJson = try JSONDecoder().decode(CartListModel.self, from: response)
                if responseJson.status == 200 {
                    DispatchQueue.main.async {
                        if responseJson.data!.count != 0 {
                            self.tabBarController?.tabBar.items?[3].badgeValue = "\(responseJson.data?.count ?? 0)"
                        }else{
                            self.tabBarController?.tabBar.items?[3].badgeValue = nil
                        }
                    }
                }else{
                    DispatchQueue.main.async {
                        
                        self.tabBarController?.tabBar.items?[3].badgeValue = nil
                       
                    }
                }
            }catch{
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Adding product to whishlist
    func addingToWishlist(cat_id:String, pro_id:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": cat_id
        ]
        
        RestService.serviceCall(url: addWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToWishlist.self, from: response) else{return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.userWishList(uid: UserDefaults.standard.string(forKey: "userid")!)
                    self.userBestSellerList(uid: UserDefaults.standard.string(forKey: "userid")!)
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //removefrom wishlist
    func removeWishlist(pro_id:String, catg_id:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": catg_id
        ]
        
        RestService.serviceCall(url: deleteWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(RemoveWishlist.self, from: response) else{return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.userWishList(uid: UserDefaults.standard.string(forKey: "userid")!)
                    self.userBestSellerList(uid: UserDefaults.standard.string(forKey: "userid")!)
                    self.cartTotal()
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Add to cart
    func addToCart(pid:String, price:String, quantityNo:String) {
        
        let charSet = CharacterSet(charactersIn: " kg")
        let trim = quantityNo.trimmingCharacters(in: charSet)
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": "",
            "price": price,
            "quantity": quantityNo
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            if responseJson.status == 200 {
                DispatchQueue.main.async {
                    self.userBestSellerList(uid: UserDefaults.standard.string(forKey: "userid")!)
                    self.cartTotal()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //wishlist list items
    func userWishList(uid:String) {
        
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: listWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            
            do{
                let responseJson = try JSONDecoder().decode(WishlistListModel.self, from: response)
                
                if responseJson.status == 200 {
                    print(responseJson.data.count, "WishlistCount")
                    DispatchQueue.main.async {
                        if responseJson.data.count != 0 {
                            self.tabBarController?.tabBar.items?[2].badgeValue = "\(responseJson.data.count ?? 0)"
                        }
                        
                    }
                }else{
                    DispatchQueue.main.async {
                        if responseJson.data.count != 0 {
                            self.tabBarController?.tabBar.items?[2].badgeValue = "\(responseJson.data.count ?? 0)"
                        }else{
                            self.tabBarController?.tabBar.items?[2].badgeValue = nil
                        }
                    }
                }
            }catch{
                self.tabBarController?.tabBar.items?[2].badgeValue = nil
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            print(error.localizedDescription)
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Delete item from cart
    func removeItemFromCart(uid:String, pid:String) {
        let params = [
            "uid": uid,
            "pid":pid
        ]
        
        RestService.serviceCall(url: deleteCart_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            
            do{
                let responseJson = try JSONDecoder().decode(RemoveCartModel.self, from: response)
                //self.removeCartModel = responseJson
                if responseJson.status == 200 {
                    self.userBestSellerList(uid: UserDefaults.standard.string(forKey: "userid")!)
                }else{
                    showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                }
            }catch{
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    @IBAction func notificationsBtnAction(_ sender: Any) {
        // notification or search icon based on login.
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            let vc = self.storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: false, completion: nil)
        }else {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to view notifications")
        }
    }
    
    @IBAction func seeMoreBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoryofFishViewController") as! StoryofFishViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func ourPremisesBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "QualityServicesViewController") as! QualityServicesViewController
        self.present(vc, animated: false, completion: nil)
    }
    
}

//MARK:- Extensions
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == scrollItemsCollectionView {
            if let count = categoryStaticList?.data?.count {
                return count
            }else{
                return 0
            }
        } else if collectionView == sliderCollectionView {
            if let count = autoImgScrollModel?.data?.count {
                return count
            }else{
                return 0
            }
            
        } else if collectionView == categoryCollectionView {
            if let count = listAllProductCategory?.data?.count {
                return count
            }else{
                return 0
            }
        } else{
            if let count = bestSeller?.data?.count {
                return count
            }else{
                return 0
            }
        }
        
    }
    
    //scroll delegate for scroll images
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        counter = Int(sliderCollectionView.contentOffset.x/sliderCollectionView.frame.size.width)
        pageView.currentPage = counter
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == sliderCollectionView {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
            if let vc = cell.viewWithTag(111) as? UIImageView {
                vc.layer.masksToBounds = true
                vc.contentMode = .scaleAspectFit
                
                let resizingProcessor = ResizingImageProcessor(referenceSize: CGSize(width: collectionView.frame.size.width * UIScreen.main.scale, height: collectionView.frame.size.height * UIScreen.main.scale))
                
                let url = autoImgScrollModel!.data![indexPath.row].imageIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""
                vc.kf.setImage(with: URL(string: url)!, placeholder: UIImage.init(named: ""), options: [
                    .processor(resizingProcessor),
                    // .scaleFactor(UIScreen.main.scale),
                    .transition(.fade(1)),
                    // .cacheOriginalImage
                ], progressBlock: nil, completionHandler: { (data) in
                    //print(data, "banner images")
                })
                
//                vc.sd_setImage(with: URL(string: autoImgScrollModel!.data![indexPath.row].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""), placeholderImage: UIImage(named: ""))
                
            }
            return cell
            
        } else if collectionView == categoryCollectionView {
            
            let cell = categoryCollectionView.dequeueReusableCell(withReuseIdentifier: "HomeCategoryCollectionViewCell", for: indexPath) as! HomeCategoryCollectionViewCell
            
            cell.imageView.sd_setImage(with: URL(string: listAllProductCategory!.data?[indexPath.row].imageIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""), placeholderImage: UIImage(named: ""))
            cell.categoryTitle.text = listAllProductCategory?.data?[indexPath.row].name ?? ""
            
            return cell
            
        } else if collectionView == bestSellersCollectionView {
            
            let cell = bestSellersCollectionView.dequeueReusableCell(withReuseIdentifier: "BestSellersCollectionViewCell", for: indexPath) as! BestSellersCollectionViewCell
            
            guard let product = bestSeller?.data?[indexPath.row] else{return UICollectionViewCell()}
            
            cell.titleLbl.text = product.productName
            cell.amountLbl.text = product.productPrice
            cell.imageView.sd_setImage(with: URL(string: product.imageIos!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: ""))
            cell.descriptionLbl.text = product.productDiscription
            cell.quantityLbl.text = product.productWeight
            cell.addToCartBtn.tag = indexPath.row
            cell.addToCartBtn.addTarget(self, action: #selector(onTapAddToCart(_:)), for: .touchUpInside)
            
            cell.moveToWishlistBtn.tag = indexPath.row
            cell.moveToWishlistBtn.addTarget(self, action: #selector(onTapWishlist(_:)), for: .touchUpInside)
            
            cell.minBtn.tag = indexPath.row
            cell.maxBtn.tag = indexPath.row
            cell.minBtn.addTarget(self, action: #selector(minBtnAction(_:)), for: .touchUpInside)
            cell.maxBtn.addTarget(self, action: #selector(maxBtnAction(_:)), for: .touchUpInside)
            
            print(bestSeller!.data?[indexPath.row].id, "prdt id")
            print(bestSeller!.data?[indexPath.row].catID, "cat id")
            print(indexPath.row, "row id")
            
            cell.quantityBtn.setTitle("1", for: .normal)
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                
                if product.wishlist == "Yes" {
                    cell.moveToWishlistBtn.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
                }else{
                    cell.moveToWishlistBtn.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
                }
                
                if bestSeller!.data![indexPath.row].cart == "Yes" {
                    cell.addToCartBtn.isHidden = true
                    cell.quantityBtn.setTitle("\(bestSeller!.data?[indexPath.row].quantity ?? "0")", for: .normal)
                }else{
                    cell.addToCartBtn.isHidden = false
                }
                
            }else{
                
                cell.moveToWishlistBtn.setImage(#imageLiteral(resourceName: "Like"), for: .normal)
                
                indexLits.removeAll()
                print(bestSeller!.data?[indexPath.row].id, "prdt id")
                print(bestSeller!.data?[indexPath.row].catID, "cat id")
                print(indexPath.row, "row id")
                fetchRequestProductResult(prdtId: bestSeller!.data?[indexPath.row].id ?? "",cateId: bestSeller!.data?[indexPath.row].catID ?? "")
                
                if indexLits.count > 0 {
                    let person = indexLits[0]
                    if person.value(forKey: "productId") as? String == bestSeller!.data?[indexPath.row].id && person.value(forKey: "categoryId") as? String == bestSeller!.data?[indexPath.row].catID{
                        cell.addToCartBtn.isHidden = true
                        cell.quantityBtn.setTitle("\(person.value(forKey: "qty") ?? "")", for: .normal)
                    }else{
                        cell.addToCartBtn.isHidden = false
                    }
                }else{
                    cell.addToCartBtn.isHidden = false
                }
                
            }
            
            if bestSeller!.data![indexPath.row].stockStatus == "0" {
                cell.outOfStockLbl.isHidden = false
                cell.addToCartBtn.isUserInteractionEnabled = false
            }else{
                cell.outOfStockLbl.isHidden = true
                cell.addToCartBtn.isUserInteractionEnabled = true
            }
            
            
            return cell
            
        } else {
            let cell = scrollItemsCollectionView.dequeueReusableCell(withReuseIdentifier: "ScrollCollectionViewCell", for: indexPath) as! ScrollCollectionViewCell
            cell.scrollImage.contentMode = .scaleAspectFit
            cell.scrollImage.sd_setImage(with: URL(string: categoryStaticList!.data?[indexPath.row].fixedCategoryIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""), placeholderImage: UIImage(named: ""))
            cell.scrollLabel.text = categoryStaticList!.data?[indexPath.row].name ?? ""
            return cell
        }
        
    }
    
    @objc func minBtnAction(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "userid") != nil {
            print("minbutton")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = bestSellersCollectionView.cellForItem(at: indexpath) as! BestSellersCollectionViewCell
            
            quantity = 0
            price = ""
            
            quantity = Int(bestSeller!.data?[sender.tag].quantity ?? "")!
            
            if quantity > 1 {
                quantity -= 1
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * (bestSeller!.data![sender.tag].productPrice! as NSString).integerValue)"
                print(quantity, price)
                
                DispatchQueue.main.async {
                    self.addToCart(pid: self.bestSeller!.data?[sender.tag].id ?? "", price: self.price, quantityNo: "\(self.quantity)")
                }
                
            }else if quantity == 1 {
                //remove from cart
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
                removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: self.bestSeller!.data?[sender.tag].id ?? "")
            }
        }else{
            //before login
            
            print("minbutton")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = bestSellersCollectionView.cellForItem(at: indexpath) as! BestSellersCollectionViewCell
            
            quantity = 0
            price = ""
            var str:String = ""
            fetchRequestProductResult(prdtId: bestSeller!.data?[sender.tag].id ?? "",cateId: bestSeller!.data?[sender.tag].catID ?? "")
            if indexLits.count > 0 {
                let person = indexLits[0]
                if person.value(forKey: "productId") as? String == bestSeller!.data?[sender.tag].id ?? ""{
                    str = person.value(forKey: "qty") as! String
                    quantity = Int(str) ?? 0
                }
            }
            
            // quantity = Int(bestSeller!.data[sender.tag].quantity)!
            
            if quantity > 1 {
                quantity -= 1
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * ((bestSeller!.data?[sender.tag].productPrice! ?? "") as NSString).integerValue)"
                print(quantity, price, " price, quantity best seller")
                
                DispatchQueue.main.async {
                    self.updsteDB(prdtId: self.bestSeller!.data?[sender.tag].id ?? "", cateId: self.bestSeller!.data?[sender.tag].catID ?? "", qty: "\(self.quantity)", priceQty: self.bestSeller!.data?[sender.tag].productPrice ?? "")
                    self.bestSellersCollectionView.reloadData()
                }
                
            }else if quantity == 1 {
                //add to cart button
                //db deletion
                self.tabBarController?.tabBar.items?[3].badgeValue = nil
                deleteItem(prdtId: self.bestSeller!.data?[sender.tag].id ?? "")
            }
            
        }
    }
    
    //coredata delete item
    func deleteItem(prdtId: String)  {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        if !prdtId.isEmpty {
            request.predicate = NSPredicate(format: "productId = %@", prdtId)
        }
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            for data in result as! [NSManagedObject] {
                context.delete(data)
                print("DELETED COREDATA DATA------->>>\(data)")
                // print(fetchRequestResult(itemId: ""))
                fetchRequestResult()
                try context.save()
                self.bestSellersCollectionView.reloadData()
            }
        } catch {
            print(" deleteItem Failed")
        }
    }
    
    @objc func maxBtnAction(_ sender: UIButton) {
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            quantity = 0
            price = ""
            
            print("maxbutton")
            quantity = Int(bestSeller!.data?[sender.tag].quantity ?? "")!
            print(quantity,price, "maxbutton values")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = bestSellersCollectionView.cellForItem(at: indexpath) as! BestSellersCollectionViewCell
            
            if quantity > 0 {
                quantity += 1
                
                print(quantity,price, "maxbutton values")
                
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * ((bestSeller!.data?[sender.tag].productPrice! ?? "") as NSString).integerValue)"
                print(quantity, price)
                
                DispatchQueue.main.async {
                    self.addToCart(pid: self.bestSeller!.data?[sender.tag].id ?? "", price: self.price, quantityNo: "\(self.quantity)")
                }
                
            }
            
        }else{
            //before login
            quantity = 0
            price = ""
            
            print("maxbutton")
            var str = ""
            fetchRequestProductResult(prdtId: bestSeller!.data?[sender.tag].id ?? "",cateId: bestSeller!.data?[sender.tag].catID ?? "")
            if indexLits.count > 0 {
                let person = indexLits[0]
                if person.value(forKey: "productId") as? String == bestSeller!.data?[sender.tag].id ?? ""{
                    str = person.value(forKey: "qty") as! String
                    quantity = Int(str) ?? 0
                }
            }
            
            print(quantity,price, "maxbutton values")
            let indexpath = IndexPath(row: sender.tag, section: 0)
            let cell = bestSellersCollectionView.cellForItem(at: indexpath) as! BestSellersCollectionViewCell
            
            if quantity > 0 {
                quantity += 1
                
                print(quantity,price, "maxbutton values")
                
                cell.quantityBtn.setTitle("\(quantity) kg", for: .normal)
                price = "\(quantity * ((bestSeller!.data?[sender.tag].productPrice! ?? "") as NSString).integerValue)"
                print(quantity, price, "bestseller price quantity maxbtn")
                
                DispatchQueue.main.async {
                    self.updsteDB(prdtId: self.bestSeller!.data?[sender.tag].id ?? "", cateId: self.bestSeller!.data?[sender.tag].catID ?? "", qty: "\(self.quantity)", priceQty: self.bestSeller!.data?[sender.tag].productPrice ?? "")
                    //check the label text it is fluctuating
                    self.bestSellersCollectionView.reloadData()
                }
                
            }
        }
        
    }
    
    @objc func onTapWishlist(_ sender: UIButton) {
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            if bestSeller!.data?[sender.tag].wishlist == "Yes" {
                removeWishlist(pro_id: bestSeller!.data?[sender.tag].id ?? "", catg_id: bestSeller!.data?[sender.tag].catID ?? "")
            }else{
                addingToWishlist(cat_id: bestSeller!.data?[sender.tag].catID ?? "", pro_id: bestSeller!.data?[sender.tag].id ?? "")
            }
            
            userWishList(uid: UserDefaults.standard.string(forKey: "userid")!)
        }else{
            //self.tabBarController?.tabBar.items?[3].badgeValue = "0"
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to add to wishlist")
        }
    }
    
    @objc func onTapAddToCart(_ sender: UIButton) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AddToCartPopupVC") as! AddToCartPopupVC
        vc.modalPresentationStyle = .overCurrentContext
        
        guard let product = bestSeller?.data?[sender.tag] else{return}
        vc.cid = product.catID ?? ""
        vc.pid = product.id ?? ""
        vc.price = product.productPrice ?? ""
        vc.tag = sender.tag
        vc.productName = product.productName ?? ""
        vc.productImage = product.productPhotos ?? ""
        vc.delegate = self
        present(vc, animated: false, completion: nil)
        
        print(vc.cid, vc.pid, "cat and product id")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == scrollItemsCollectionView {
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductsListViewController") as! ProductsListViewController
            vc.cid = categoryStaticList!.data?[indexPath.row].catID ?? ""
            self.present(vc, animated: false, completion: nil)
            
        }else if collectionView == categoryCollectionView {
            let vc = storyboard?.instantiateViewController(identifier: "ProductsListViewController") as! ProductsListViewController
            vc.cid = listAllProductCategory!.data?[indexPath.row].id ?? ""
            print(listAllProductCategory!.data?[indexPath.row].id)
            self.present(vc, animated: false, completion: nil)
        }else if collectionView == bestSellersCollectionView {
            
            let vc = storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
            vc.cid = bestSeller!.data?[indexPath.row].catID ?? ""
            vc.pid = bestSeller!.data?[indexPath.row].id ?? ""
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
}

extension HomeViewController: UICollectionViewDelegateFlowLayout, AddCartProtocol {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if collectionView == sliderCollectionView
        {
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        else if collectionView == categoryCollectionView
        {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
        else if collectionView == scrollItemsCollectionView
        {
            return UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        else
        {
            return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if collectionView == sliderCollectionView
        {
            let size = sliderCollectionView.frame.size
            return CGSize(width: size.width, height: size.height)
        }
        else if collectionView == categoryCollectionView
        {
            let width  = (categoryCollectionView.frame.width - 21)/3
            return CGSize(width: width, height: 100)
        }
        else if collectionView == scrollItemsCollectionView
        {
            return CGSize(width: 80, height: 60)
        }
        else
        {
            return CGSize(width: 230, height: 220)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == sliderCollectionView
        {
            return 0.0
        }else if collectionView == categoryCollectionView {
            return 8.0
        }else if collectionView == bestSellersCollectionView {
            return 7.0
        }else {
            return 10.0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if collectionView == scrollItemsCollectionView{
            return 10.0
        }else{
            return 0.0
        }
    }
    
        //Fetch all records Result //not used
        func fetchRequestResult() {
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            prdtListArray = try managedContext.fetch(fetchRequest)
            print(prdtListArray)
            
            if prdtListArray.count != 0 {
                self.tabBarController?.tabBar.items?[3].badgeValue = "\(prdtListArray.count)"
            }
            //Added:-
            self.bestSellersCollectionView.reloadData()
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    //UpdatedDB
    func updsteDB(prdtId :String,cateId :String,qty:String, priceQty:String)  {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
        fetchRequest.predicate = NSPredicate(format: "productId = %@ && categoryId = %@", prdtId ,cateId )
        
        do {
            //            let managedContext = appDelegate.persistentContainer.viewContext
            //                  let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
            //            let userName = NSManagedObject(entity: entity, insertInto: managedContext)
            //                   userName.setValue(pname, forKeyPath: "prdtname")
            //                   userName.setValue(prdtId, forKeyPath: "productId")
            //                   userName.setValue(cids, forKeyPath: "categoryId")
            //                   userName.setValue(qty, forKeyPath: "qty")
            //                   userName.setValue(image, forKeyPath: "image")
            //                   userName.setValue(prefe, forKeyPath: "preferences")
            //                    userName.setValue(price, forKeyPath: "price")
            
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(qty, forKeyPath: "qty")
                results![0].setValue(priceQty, forKeyPath: "price")
                self.bestSellersCollectionView.reloadData()
            }
        } catch {
            print("Fetch Failed: \(error)")
        }
        
        do {
            try context.save()
        }
        catch {
            print("Saving Core Data Failed: \(error)")
        }
    }
    
    //FetchRequest if product is there with pid and cid and adding it to indexlist
    func fetchRequestProductResult(prdtId :String,cateId :String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        if !prdtId.isEmpty {
            fetchRequest.predicate = NSPredicate(format: "productId = %@ && categoryId = %@", prdtId ,cateId )
        }
        do {
            indexLits = try managedContext.fetch(fetchRequest)
            print(indexLits)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
       
    }
    
    //protocol function
    func didTapCart(tagValue: String) {
        
        if Reachability.isConnectedToNetwork() {
            if UserDefaults.standard.string(forKey: "userid") != nil {
                guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
                self.userBestSellerList(uid: uid)
                self.cartTotal()
            }else{
                  fetchRequestResult()
                self.userBestSellerList(uid: "")
                self.bestSellersCollectionView.reloadData()
            }
          
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    func sampleTest(city:String){
        print(city)
        self.UserCitylocationlbl.text = city ?? ""
    }
    
}


struct ReversedGeoLocation {
    let name: String            // eg. Apple Inc.
    let streetName: String      // eg. Infinite Loop
    let streetNumber: String    // eg. 1
    let city: String            // eg. Cupertino
    let state: String           // eg. CA
    let zipCode: String         // eg. 95014
    let country: String         // eg. United States
    let isoCountryCode: String  // eg. US
    var formattedAddress: String {
        
        return """
        \(name),
        \(streetNumber) \(streetName),
        \(city), \(state) \(zipCode)
        \(country)
        """
    }
    // Handle optionals as needed
    init(with placemark: CLPlacemark) {
        self.name           = placemark.name ?? ""
        self.streetName     = placemark.thoroughfare ?? ""
        self.streetNumber   = placemark.subThoroughfare ?? ""
        self.city           = placemark.locality ?? ""
        self.state          = placemark.administrativeArea ?? ""
        self.zipCode        = placemark.postalCode ?? ""
        self.country        = placemark.country ?? ""
        self.isoCountryCode = placemark.isoCountryCode ?? ""
        
    }
    
}
