//
//  AddressListViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
// 201129075240

import UIKit
import CoreData

class CartViewController : BaseViewController, UITableViewDelegate,UITextFieldDelegate {
    
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var continueFishingBtn: UIButton!
    @IBOutlet weak var cartListTableView: UITableView!
    @IBOutlet weak var slotsCollectionView: UICollectionView!
    
    //OrderType
    //labels
    @IBOutlet weak var pickupLbl: UILabel!
    @IBOutlet weak var deliveryLbl: UILabel!
    @IBOutlet weak var expdeliveryLbl: UILabel!
    //button
    @IBOutlet weak var pickUpBtn: UIButton!
    @IBOutlet weak var deliveryBtn: UIButton!
    @IBOutlet weak var expssDeliveryBtn: UIButton!
    //Images
    @IBOutlet weak var pickUpImage: UIImageView!
    @IBOutlet weak var deliveryImage: UIImageView!
    @IBOutlet weak var expDeliveryImage: UIImageView!
    
    
    //delivery or pickup date
    @IBOutlet weak var deliveryDateTF: UITextField!
    //coupons
    @IBOutlet weak var couponsTF: UITextField!
    @IBOutlet weak var viewCouponsBtn: UIButton!
    @IBOutlet weak var couponLbl: UILabel!
    //Totals
    @IBOutlet weak var itemTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var netTotalLbl: UIButton!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var couponAmountLbl: UILabel!
    
    //constrainst for counpon
    @IBOutlet weak var couponHeight: NSLayoutConstraint! //21
    @IBOutlet weak var couponAmountHeight: NSLayoutConstraint! //21
    
    //constraints outlets
    @IBOutlet weak var dateTFHeight: NSLayoutConstraint! //38
    @IBOutlet weak var cardViewHeight: NSLayoutConstraint! // 394
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint! // 130
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint! // 100
    @IBOutlet weak var viewHeight: NSLayoutConstraint! // 791
    @IBOutlet weak var expDlvyLbl: UILabel!
    
    //Dates pick as per delivery and pickup
    @IBOutlet weak var dateView: UIView!
    @IBOutlet weak var datePickTV: UITableView!
    @IBOutlet weak var mainView: UIView!
    
    //new api models
    var timeSlotsModel: TimeSlotsModel?
    var cartlistModel:CartListModel?
    var picDelDates:PicDelDates?
    var removeCartModel:RemoveCartModel?
    var deliveryChargesModel:DeliveryChargesModel?
    var addToCartBtnModel:AddToCartBtnModel?// increase or decrease quantity
    var deliveryTypeList:DeliveryTypeList?
    
    var SlotsSelectedCell : String!
    
    var tap: UITapGestureRecognizer!
    
    var isComing = String()
    
    //TV VALUE
    var count = Int()
    var dateCount = Int()
    var deliveryData = ""
    
    //Cart quantity values
    var quantity = Int()
    //cart total
    var total = Int()
    
    //delivery date
    var deliverType = String()
    var cartItemsData = [[String:String]]()
    
    //CoreData Arrays
    var productListArray:[NSManagedObject] = []
    var indexList:[NSManagedObject]=[]
    
    var totalArray = [Int]()
    
    var couponDiscount = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        expDlvyLbl.isHidden = true
        pickUpBtn.layer.cornerRadius = 10
        deliveryBtn.layer.cornerRadius = 10
        expssDeliveryBtn.layer.cornerRadius = 10
        
        deliverType = UserDefaults.standard.string(forKey: "deliveryType")!
        
        if deliverType == "pickup" {
            deliveryDateTF.placeholder = "Select a date for pickup"
            pickupBtn()
        }else{
            deliveryDateTF.placeholder = "Select a date for delivery"
            deliveryBtnAction()
        }
        
        if UserDefaults.standard.string(forKey:"userid") != nil {
            
            if Reachability.isConnectedToNetwork() {
                getDeliveryType()
                
                if cartValue == "cart" {
                    fetchRequestResult()
                    for i in 0..<self.productListArray.count {
                        print(self.productListArray.count, "cart count")
                        let product = self.productListArray[i]
                        print(self.productListArray[i], "before cart values details")
                        
                        let proPrice = (product.value(forKey: "price") as! NSString).integerValue * (product.value(forKey: "qty") as! NSString).integerValue
                        
                        self.addToCart(product_ID: product.value(forKey: "productId") as! String, cuttingPref: product.value(forKey: "preferences") as! String, price: "\(proPrice)", qunatity: product.value(forKey: "qty") as! String, uid: UserDefaults.standard.string(forKey: "userid")!)
                        
                        print(self.productListArray[i], "aftercart values details")
                    }
                }else{
                    cartList()
                }
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }else{
            
            let vc = storyboard?.instantiateViewController(identifier: "BeforeLoginVC") as! BeforeLoginVC
            addChild(vc)
            mainView.addSubview(vc.view)
            vc.view.frame = mainView.frame
            vc.didMove(toParent: self)
            
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.addGestureRecognizer(tap)
        
    }
    @objc private func onTap(sender: UITapGestureRecognizer) {
        //self.view.window?.removeGestureRecognizer(sender)
        self.dateView.isHidden = true
    }
    
    //MARK:- selectors
    @IBAction func onTapContinueFishing(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
        present(vc, animated: false, completion: nil)
    }
    
    @IBAction func onTapPickUpBtn(_ sender: Any) {
        
        pickupBtn()
    }
    
    func pickupBtn() {
        
        deliveryDateTF.placeholder = "Select a date for Pickup"
        deliveryDateTF.text = ""//deliveryData
        deliveryDateTF.isHidden = false
        dateTFHeight.constant = 38
        if self.count > 1 {
            self.tableViewHeight.constant = CGFloat(self.count * 122)
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135)
            self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394) - 100
        }else if self.count == 1 {
            self.tableViewHeight.constant = 112
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 - 100
            self.viewHeight.constant = 791 - 100
        }
        
        pickUpBtn.setTitleColor(.white, for: .normal)
        deliveryBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        expssDeliveryBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        
        pickUpBtn.backgroundColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 0.5)
        deliveryBtn.backgroundColor = .clear
        expssDeliveryBtn.backgroundColor = .clear
        deliverType = "pickup"
        expDlvyLbl.isHidden = true
    }
    
    @IBAction func onTapDeliveryBtn(_ sender: Any) {
        
        if cartScreenValue == "pickup" {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Not Available")
        }else{
            deliveryBtnAction()
        }
        
    }
    
    func deliveryBtnAction() {
        homeScreenValue = "delivery"
        deliveryDateTF.placeholder = "Select a date for delivery"
        deliveryDateTF.text = ""//deliveryData
        deliveryDateTF.isHidden = false
        dateTFHeight.constant = 38
        if self.count > 1 {
            self.tableViewHeight.constant = CGFloat(self.count * 122)
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135)
            self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394) - 100
        }else if self.count == 1 {
            self.tableViewHeight.constant = 112
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 - 100
            self.viewHeight.constant = 791 - 100
        }
        
        
        deliveryBtn.setTitleColor(.white, for: .normal)
        pickUpBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        expssDeliveryBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        
        deliveryBtn.backgroundColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 0.5)
        pickUpBtn.backgroundColor = .clear
        expssDeliveryBtn.backgroundColor = .clear
        
        deliverType = "delivery"
        expDlvyLbl.isHidden = true
        
        if homeScreenValue == "pickup" {
            cartScreenValue = "delivery"
        }
        
    }
    
    @IBAction func onTapExpssDeliveryBtn(_ sender: Any) {
        if cartScreenValue == "pickup" {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Not Available")
        }else{
            if self.deliveryTypeList?.data?[2].status ?? "0" == "0" {
                showAlertMessage(vc: self, titleStr: "", messageStr: "Not Available")
            }else{
                expDeliveryBtnAction()
            }
        }
        
    }
    
    func expDeliveryBtnAction() {
        homeScreenValue = "delivery"
        deliveryDateTF.placeholder = "Select a date for delivery"
        deliveryDateTF.text = ""
        dateTFHeight.constant = self.expDlvyLbl.intrinsicContentSize.height
        deliveryDateTF.isHidden = true
        if self.count > 1 {
            self.tableViewHeight.constant = CGFloat(self.count * 122)
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135) - 48 + self.expDlvyLbl.intrinsicContentSize.height
            self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394) - 100
        }else if self.count == 1 {
            self.tableViewHeight.constant = 112
            self.collectionViewHeight.constant = 0
            self.cardViewHeight.constant = 394 - 100 - 48 + self.expDlvyLbl.intrinsicContentSize.height
            self.viewHeight.constant = 791 - 100 - 48 + self.expDlvyLbl.intrinsicContentSize.height
        }
        
        expssDeliveryBtn.setTitleColor(.white, for: .normal)
        deliveryBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        pickUpBtn.setTitleColor(#colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1), for: .normal)
        
        expssDeliveryBtn.backgroundColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 0.5)
        pickUpBtn.backgroundColor = .clear
        deliveryBtn.backgroundColor = .clear
        
        deliverType = "Exp delivery"
        expDlvyLbl.isHidden = false
        
    }
    
    @objc func onDateTap(){
        
        if deliverType != "" {
            deliveryDateTF.resignFirstResponder()
            dateView.isHidden = false
            if Reachability.isConnectedToNetwork(){
                dateOfDeliveryPickup(deliverytype: deliverType)
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }else{
            showAlertMessage(vc: self, titleStr: "", messageStr: "select type of ordering")
        }
    }
    
    @objc func onTapViewCoupons() {
        let vc = storyboard?.instantiateViewController(identifier: "CouponsViewController") as! CouponsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.delegate = self
        vc.totalAmount = total
        present(vc, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        dateView.isHidden = true
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        continueFishingBtn.buttonChange(cornerRadius: 15.0, borderColor: UIColor.lightGray, borderWidth: 1.0)
        
        deliveryDateTF.setBorderAndCornerRadius(layer: deliveryDateTF.layer, width: 1, radius: 16, color: #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1))
        couponsTF.setBorderAndCornerRadius(layer: couponsTF.layer, width: 0, radius: 16, color: #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0))
        
        deliveryDateTF.addTarget(self, action: #selector(onDateTap), for: .allEvents)
        deliveryDateTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        deliveryDateTF.leftViewMode = .always
        couponsTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 5))
        couponsTF.leftViewMode = .always
        
        viewCouponsBtn.addTarget(self, action: #selector(onTapViewCoupons), for: .touchUpInside)
        
        cartListTableView.estimatedRowHeight = 122
        cartListTableView.rowHeight = UITableView.automaticDimension
        cartListTableView.delegate = self
        cartListTableView.dataSource = self
        
        slotsCollectionView.delegate = self
        slotsCollectionView.dataSource = self
        
        datePickTV.delegate = self
        datePickTV.dataSource = self
        datePickTV.estimatedRowHeight = 55
        datePickTV.rowHeight = UITableView.automaticDimension
        
        slotsCollectionView.register(TimeSlotsCVCell.nib(), forCellWithReuseIdentifier: TimeSlotsCVCell.identifier)
        
        couponHeight.constant = 0
        couponAmountHeight.constant = 0
        
        deliverType = UserDefaults.standard.string(forKey: "deliveryType")!
        
        if deliverType == "pickup"{
            deliverType = "pickup"
            pickupBtn()
            
        }else if deliverType == "delivery" {
            
            deliverType = "delivery"
            deliveryBtnAction()
        }
        
    }
    
    
    //MARK:- API's
    //cart details list
    func cartList() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "uid": uid
        ]
        
        RestService.serviceCall(url: cartList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do{
                let responseJson = try JSONDecoder().decode(CartListModel.self, from: response)
                if responseJson.status == 200 {
                    self.cartlistModel = responseJson
                    print(responseJson.data!.count, "cart value")
                    
                    DispatchQueue.main.async {
                        self.count = responseJson.data!.count
                        if self.count > 1 {
                            self.tableViewHeight.constant = CGFloat(self.count * 122)
                            self.collectionViewHeight.constant = 0
                            self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135)
                            self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394) - 100
                        }else if self.count == 1 {
                            self.tableViewHeight.constant = 112
                            self.collectionViewHeight.constant = 0
                            self.cardViewHeight.constant = 394 - 100
                            self.viewHeight.constant = 791 - 100
                        }else if self.count == 0 {
                            let alert = UIAlertController(title: "", message: "Your cart is empty", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Start Fishing", style: .default, handler: { (alerts) in
                                
                                let vc = self.storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
                                self.present(vc, animated: false, completion: nil)
                            }))
                            
                            self.present(alert, animated: true, completion: nil)
                        }
                        
                        self.deliveryGstCharges()
                        self.cartListTableView.reloadData()
                        self.tabBarController?.tabBar.items?[3].badgeValue = "\(responseJson.data?.count ?? 0)"
                    }
                    
                }else{
                    let alert = UIAlertController(title: "", message: "Your cart is empty", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Start Fishing", style: .default, handler: { (alerts) in
                        self.tabBarController?.tabBar.items?[3].badgeValue = nil
                        let vc = self.storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
                        self.present(vc, animated: false, completion: nil)
                    }))
                    
                    self.present(alert, animated: true, completion: nil)
                }
            }catch{
                print(error.localizedDescription)
                showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Adding product to whishlist
    func addingToWishlist(cat_id:String, pro_id:String, uid:String) {
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": cat_id
        ]
        
        RestService.serviceCall(url: addWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do{
                let responseJson = try JSONDecoder().decode(AddWishlist.self, from: response)
                
                if responseJson.status == 200 {
                    self.removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: pro_id)
                    print(responseJson.message, "vikas")
                }else{
                    print("vikas1")
                    self.removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: pro_id)
                }
            }catch{
                print("vikas2", cat_id, pro_id, error.localizedDescription)
            }
        }) { (error) in
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
                self.removeCartModel = responseJson
                if responseJson.status == 200 {
                    self.cartList()
                    
                }else{
                    print("error 1")
                    showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                }
            }catch{
                print("error 2")
                showAlertMessage(vc: self, titleStr: "", messageStr: self.removeCartModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //dates based on pickup and delivery
    func dateOfDeliveryPickup(deliverytype:String) {
        
        let params = [
            "type": deliverytype
        ]
        
        RestService.serviceCall(url: datePicked_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            
            guard let responseJson = try? JSONDecoder().decode(PicDelDates.self, from: response) else{return}
            self.picDelDates = responseJson
            if responseJson.status == true {
                
                DispatchQueue.main.async {
                    self.dateCount = responseJson.data?.count ?? 0
                    self.datePickTV.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.picDelDates!.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Time slots for date picked
    func timeSlotsCarts(pickDate:String) {
        
        let params = [
            "date": pickDate
        ]
        print(params)
        RestService.serviceCall(url: timeSlots_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(TimeSlotsModel.self, from: response) else{return}
            self.timeSlotsModel = responseJson
            
            if responseJson.status == true {
                
                print(responseJson.data?.count, "success")
                
                if responseJson.data?.count ?? 0 == 0 {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "No slots available today")
                }
                DispatchQueue.main.async {
                    self.slotsCollectionView.reloadData()
                }
                
            }else{
                print(responseJson.data, "success2")
                showAlertMessage(vc: self, titleStr: "", messageStr: self.timeSlotsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //delivery and Gst charges
    func deliveryGstCharges() {
        
        RestService.serviceCall(url: charges_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(DeliveryChargesModel.self, from: response) else{return}
            self.deliveryChargesModel = responseJson
            if responseJson.status == 200 {
                
                let gst = responseJson.data?[0].gst ?? ""
                let gstValue = (gst as NSString).floatValue
                
                let deliveryCharges = responseJson.data?[0].deliveryCharge ?? ""
                let delValue = (deliveryCharges as NSString).floatValue
                
                if self.couponsTF.text != "" {
                    self.couponHeight.constant = 21
                    self.couponAmountHeight.constant = 21
                    self.couponAmountLbl.text = "\(self.couponDiscount)"
                    self.couponLbl.text = "Coupon Code has been applied successfully!"
                }
                
                let gstCal = (Float(self.total - self.couponDiscount) * gstValue) / 100
                
                print((Float(self.total) * gstValue), gstValue, Float(self.total), gstCal, "totals")
                
                self.itemTotalLbl.text = "\(self.total - self.couponDiscount)"
                self.gstLbl.text = "\(gstCal)"
                self.deliveryChargesLbl.text = self.deliveryChargesModel!.data?[0].deliveryCharge ?? ""
                
                
                let netTotal = Float(self.total - self.couponDiscount) + Float(gstCal) + Float(delValue)
                print(netTotal, self.total, "nettotal, total")
                self.netTotalLbl.setTitle(String(format: "%.2f", netTotal), for: .normal)
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.deliveryChargesModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
    func addToCart(cid:String, pid:String, quantity:String, price: String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": cid,
            "price": price,
            "quantity": quantity
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.cartList()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //deliveryType names and images
    func getDeliveryType() {
        
        RestService.serviceCall(url: getDeliveryType_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(DeliveryTypeList.self, from: response) else{return}
            self.deliveryTypeList = responseJson
            
            if responseJson.status == 200 {
                
                var imageArray = [UIImage]()
                
                for x in 0..<responseJson.data!.count {
                    
                    if let url = URL(string: responseJson.data?[x].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? "") {
                        
                        do{
                            let urlData = try Data(contentsOf: url)
                            imageArray.append(UIImage(data: urlData)!)
                        }catch{
                            print(error.localizedDescription, "getDeliveryTypeImages")
                        }
                    }
                    
                }
                
                print(imageArray, "delivery type images", responseJson.data?.count)
                //image
                self.expDlvyLbl.text = responseJson.data?[2].alert ?? ""
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.deliveryTypeList!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        if UserDefaults.standard.string(forKey:"FromTab") == "Yes" {
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }else{
            dismiss(animated:false)
        }
        
    }
    
    @IBAction func checkOutBtnAction(_ sender: Any) {
        
        print(deliverType, "delivery type checking")
        
        if deliverType == "Exp delivery" {
            
            let vc = storyboard?.instantiateViewController(identifier: "DeliverySummaryVC") as! DeliverySummaryVC
            vc.modalPresentationStyle = .fullScreen
            
            //Date and time
            let date = Date()
            let formate = date.getFormattedDate(format: "yyyy-MM-dd") // Set output formate
            print(formate)
            
            let date1 = Date()
            let formate1 = date1.getFormattedDate(format: "HH:mm") // Set output formate
            print(formate1)
            
            //datasent
            CartDataStore.shared.deliverType = "delivery"
            CartDataStore.shared.deliveryDate = formate
            CartDataStore.shared.SlotsSelectedCell = formate1
            CartDataStore.shared.total = itemTotalLbl.text!
            CartDataStore.shared.gst = gstLbl.text!
            CartDataStore.shared.deliveryCharges = self.deliveryChargesLbl.text!
            CartDataStore.shared.netTotal = netTotalLbl.titleLabel!.text!
            CartDataStore.shared.couponAmount = "\(couponDiscount)"
            
            present(vc, animated: false, completion: nil)
            
        } else {
            if !deliverType.isEmpty && !deliveryDateTF.text!.isEmpty {
                if SlotsSelectedCell != nil {
                    
                    if deliverType == "delivery" {
                        
                        let vc = storyboard?.instantiateViewController(identifier: "DeliverySummaryVC") as! DeliverySummaryVC
                        vc.modalPresentationStyle = .fullScreen
                        
                        //datasent
                        CartDataStore.shared.deliverType = deliverType
                        CartDataStore.shared.deliveryDate = deliveryDateTF.text!
                        CartDataStore.shared.SlotsSelectedCell = SlotsSelectedCell
                        CartDataStore.shared.total = itemTotalLbl.text!
                        CartDataStore.shared.gst = gstLbl.text!
                        CartDataStore.shared.deliveryCharges = self.deliveryChargesLbl.text!
                        CartDataStore.shared.netTotal = netTotalLbl.titleLabel!.text!
                        CartDataStore.shared.couponAmount = "\(couponDiscount)"
                        //value shouldn't be nil
                        UserDefaults.standard.set("", forKey: "cart")
                        present(vc, animated: false, completion: nil)
                        
                    }else{
                        let vc = storyboard?.instantiateViewController(identifier: "PickupSummaryVC") as! PickupSummaryVC
                        vc.modalPresentationStyle = .fullScreen
                        
                        //datasent
                        CartDataStore.shared.deliverType = deliverType
                        CartDataStore.shared.deliveryDate = deliveryDateTF.text!
                        CartDataStore.shared.SlotsSelectedCell = SlotsSelectedCell
                        CartDataStore.shared.total = itemTotalLbl.text!
                        CartDataStore.shared.gst = gstLbl.text!
                        CartDataStore.shared.deliveryCharges = self.deliveryChargesLbl.text!
                        CartDataStore.shared.netTotal = netTotalLbl.titleLabel!.text!
                        CartDataStore.shared.couponAmount = "\(couponDiscount)"
                        //value shouldn't be nil
                        UserDefaults.standard.set("", forKey: "cart")
                        present(vc, animated: false, completion: nil)
                    }
                    
                }else{
                    showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Time slot not selected")
                }
            }else {
                showAlertMessage(vc: self, titleStr: "Alert", messageStr: "Date not selected")
            }
        }
        
    }
    
    
    //Add to cart after user login with products. DBcart-> login->cart
    func addToCart(product_ID:String, cuttingPref:String, price:String, qunatity:String, uid:String) {
        
        let params = [
            "uid": uid,
            "pid": product_ID,
            "cid": cuttingPref,
            "price": price,
            "quantity": qunatity
        ]
        
        print(params)
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.cartList()
                }
                cartValue = ""
                self.deleteItem(prdtId: product_ID)
                
                print("added items to cart")
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
}

extension CartViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if let count = self.timeSlotsModel?.data?.count {
            return count
        }else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = slotsCollectionView.dequeueReusableCell(withReuseIdentifier: TimeSlotsCVCell.identifier, for: indexPath) as! TimeSlotsCVCell
        
        cell.timeLbl.text = timeSlotsModel?.data?[indexPath.row].slots ?? ""
        
        if timeSlotsModel?.data?[indexPath.row].status ?? "" == "no" {
            cell.displayView.backgroundColor = #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 0.5)
            cell.timeLbl.textColor = .black
            cell.isUserInteractionEnabled = false
        }else{
            
            cell.isUserInteractionEnabled = true
            if self.deliverType == "pickup" {
                
                if SlotsSelectedCell == timeSlotsModel?.data?[indexPath.row].slots ?? "" {
                    cell.timeLbl.textColor = .white
                    cell.displayView.backgroundColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                }else{
                    cell.timeLbl.textColor = .black
                    cell.displayView.backgroundColor = .white
                }
                
            }else{
                if SlotsSelectedCell == timeSlotsModel?.data?[indexPath.row].slots ?? "" {
                    cell.timeLbl.textColor = .white
                    cell.displayView.backgroundColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                }else{
                    cell.timeLbl.textColor = .black
                    cell.displayView.backgroundColor = .white
                }
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 60, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.deliveryDateTF.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Select date")
        }else{
            if self.deliverType == "pickup" {
                self.SlotsSelectedCell = timeSlotsModel?.data?[indexPath.row].slots ?? ""
            }else{
                self.SlotsSelectedCell = timeSlotsModel?.data?[indexPath.row].slots ?? ""
            }
            slotsCollectionView.reloadData()
        }
        
    }
    
}

extension CartViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if tableView == datePickTV {
            return dateCount
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == datePickTV {
            let cell = datePickTV.dequeueReusableCell(withIdentifier: DatesTVCell.identifier, for: indexPath) as! DatesTVCell
            
            if indexPath.row == 0 || indexPath.row == 2 {
                cell.backgroundColor = UIColor.colorFromHex("#EDEEEF")
            }
            
            cell.datesLbl.text = convertDateFormater(picDelDates!.data?[indexPath.row].scalar ?? "")
            cell.selectedDateBtn.tag = indexPath.row
            cell.selectedDateBtn.addTarget(self, action: #selector(onTapdate(_:)), for: .touchUpInside)
            return cell
        }
        
        let cell : CartListTableViewCell = self.cartListTableView.dequeueReusableCell(withIdentifier: "CartListTableViewCell") as! CartListTableViewCell
        
        let cartDetails = cartlistModel?.data?[indexPath.row]
        
        if cartDetails != nil {
            cell.fishNameLbl.setTitle(cartDetails?.productName ?? "", for: .normal)
            cell.cuttingTypeLbl.text = cartDetails?.type ?? ""
            
            if cartDetails?.productPhotos != nil {
                cell.imgView.sd_setImage(with: URL(string: cartDetails!.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: ""))
            }
            cell.kgBtnOutlet.setTitle("\(cartDetails!.quantity ?? "0")", for: .normal)
            cell.amountBtnOutlet.setTitle(cartDetails!.price, for: .normal)
            
            //total and net total with charges
            total = 0
            for i in 0..<cartlistModel!.data!.count {
                
                let price = (cartlistModel!.data![i].price as! NSString).integerValue
                total = total + price
            }
            
            self.itemTotalLbl.text = "\(total)"
            print(total,"total")
            //
        }
        
        
        
        //remove 101 wish list 102 tags
        cell.removeBtnOutlet.tag = indexPath.row
        cell.removeBtnOutlet.addTarget(self, action: #selector(removeItem(_:)), for: .touchUpInside)
        
        cell.moveToWishListBtnOutlet.tag = indexPath.row
        cell.moveToWishListBtnOutlet.addTarget(self, action: #selector(moveToWishlist(_:)), for: .touchUpInside)
        
        // increase or decrease quantity
        cell.minusBtnOutlet.tag = indexPath.row
        cell.plusBtnOutlet.tag = indexPath.row
        
        cell.minusBtnOutlet.addTarget(self, action: #selector(quantyChangeMin(_:)), for: .touchUpInside)
        cell.plusBtnOutlet.addTarget(self, action: #selector(quantyChangePlus(_:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        return cell
    }
    
    @objc func onTapdate(_ sender: UIButton) {
        
        dateView.isHidden = true
        
        if Reachability.isConnectedToNetwork() {
            self.timeSlotsCarts(pickDate: picDelDates!.data?[sender.tag].scalar ?? "")
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        self.deliveryDateTF.text = convertDateFormater(picDelDates!.data?[sender.tag].scalar ?? "")
        self.tableViewHeight.constant = CGFloat(self.count * 122)
        self.collectionViewHeight.constant = 100
        self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135)
        self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394)
        
    }
    
    func convertDateFormater(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        guard let date = dateFormatter.date(from: date) else{return ""}
        dateFormatter.dateFormat = "dd MMMM yyyy, EEEE"
        return  dateFormatter.string(from: date)
        
    }
    
    @objc func quantyChangeMin(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork(){
            
            
            let value = Int(cartlistModel!.data?[sender.tag].quantity ?? "0")
            let price = Int(cartlistModel!.data?[sender.tag].productPrice ?? "0")
            
            quantity = value!
            
            if quantity > 1 {
                quantity -= 1
                
                let prices = quantity * price!
                print(quantity)
                
                self.addToCart(cid: cartlistModel!.data?[sender.tag].cid ?? "", pid: cartlistModel!.data?[sender.tag].pid ?? "", quantity: "\(quantity)", price: "\(prices)")
            }else if quantity == 1 {
                self.removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: cartlistModel!.data?[sender.tag].pid ?? "")
            }
            
            self.cartList()
            
            
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    @objc func quantyChangePlus(_ sender: UIButton) {
        
        
        let value = Int(cartlistModel!.data?[sender.tag].quantity ?? "0")
        let price = Int(cartlistModel!.data?[sender.tag].productPrice ?? "0")
        
        quantity = value!
        
        if quantity > 0 {
            quantity += 1
            let prices = quantity * price!
            print(quantity)
            
            if Reachability.isConnectedToNetwork() {
                self.addToCart(cid: cartlistModel!.data?[sender.tag].cid ?? "", pid: cartlistModel!.data?[sender.tag].pid ?? "", quantity: "\(quantity)", price: "\(prices)")
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
        
        self.cartList()
        
        
    }
    
    @objc func removeItem(_ sender: UIButton) {
        
        if Reachability.isConnectedToNetwork(){
            
            removeItemFromCart(uid: UserDefaults.standard.string(forKey: "userid")!, pid: cartlistModel!.data?[sender.tag].pid ?? "")
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    @objc func moveToWishlist(_ sender: UIButton) {
        if Reachability.isConnectedToNetwork(){
            
            self.addingToWishlist(cat_id: cartlistModel!.data?[sender.tag].catID ?? "", pro_id: cartlistModel!.data?[sender.tag].pid ?? "", uid: UserDefaults.standard.string(forKey: "userid")!)
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == datePickTV {
            self.deliveryDateTF.text = convertDateFormater(picDelDates!.data?[indexPath.row].scalar ?? "")
            self.dateView.isHidden = true
            
            if Reachability.isConnectedToNetwork() {
                self.timeSlotsCarts(pickDate: picDelDates!.data?[indexPath.row].scalar ?? "")
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
            
            self.tableViewHeight.constant = CGFloat(self.count * 122)
            self.collectionViewHeight.constant = 100
            self.cardViewHeight.constant = 394 + (self.tableViewHeight.constant - 135)
            self.viewHeight.constant = 791 + (self.cardViewHeight.constant - 394)
            
        }
    }
    
    //MARK:-Coredata
    //Fetch all records Result
    func fetchRequestResult() {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
        
        do {
            productListArray = try managedContext.fetch(fetchRequest)
            print(productListArray)
            self.count = productListArray.count
            print(self.count, "list cart count")
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
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
                
            }
        } catch {
            print("deleteItem Failed")
        }
    }
    
}

extension CartViewController:CouponCode {
    
    func getCoupon(coupon: String, amount: String) {
        self.couponsTF.text = coupon
        self.couponLbl.text = "Coupon Code has been applied successfully!"
        self.couponDiscount = Int(amount)!
        self.deliveryGstCharges()
        
    }
    
}

extension CartViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.dateView)
    }
}
