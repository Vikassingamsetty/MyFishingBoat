//
//  PickupSummaryVC.swift
//  MyFishingBoat
//
//  Created by vikas on 06/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import Razorpay

class PickupSummaryVC: BaseViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var pickupTV: UITableView!
    @IBOutlet weak var pickupTVHeight: NSLayoutConstraint!
    @IBOutlet weak var storeNameLbl: UILabel!
    @IBOutlet weak var storeKmLbl: UILabel!
    @IBOutlet weak var storeAddrLbl: UILabel!
    @IBOutlet weak var itemTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargesLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var netTotalLbl: UILabel!
    @IBOutlet weak var changeBtn: CustomButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint! //670 default
    
    
    //Model
    var cartlistModel:CartListModel?
    var pickupOrderModel:PickupOrderModel?
    var checkPickupSummaryModel:CheckPickupSummaryModel?
    
    //Payment
    var razorpay: RazorpayCheckout!
    
    //Tvcount
    var count = Int()
    
    //get values from cart
    var cartItemsData = [[String:String]]()
    
    var amount = Double()
    
    var comingFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        pickupTV.delegate = self
        pickupTV.dataSource = self
        pickupTV.register(PickUpDelivTVCell.nib(), forCellReuseIdentifier: PickUpDelivTVCell.identifier)
        pickupTV.estimatedRowHeight = 118
        pickupTV.rowHeight = UITableView.automaticDimension
   
        itemTotalLbl.text = CartDataStore.shared.total
        deliveryChargesLbl.text = CartDataStore.shared.deliveryCharges
        gstLbl.text = CartDataStore.shared.gst
        netTotalLbl.text = CartDataStore.shared.netTotal
        
        //PaymentGTW
        //Live key
        razorpay = RazorpayCheckout.initWithKey("rzp_live_5H2UxS5y4suC9T", andDelegate: self)
        //Demo key
        //razorpay = RazorpayCheckout.initWithKey("rzp_test_cSoYdsrxct1EZA", andDelegate: self)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            
            cartList()
            
            storeNameLbl.text = StoreDetailsData.shared.storeName
            storeAddrLbl.text = StoreDetailsData.shared.storeAddress
            storeKmLbl.text = StoreDetailsData.shared.km
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        if storeAddrLbl.text!.isEmpty {
            changeBtn.setTitle("SELECT", for: .normal)
        }else{
            changeBtn.setTitle("CHANGE", for: .normal)
        }
    }
    
    //MARK:Selector
    @IBAction func onTapPickStore(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
        vc.modalPresentationStyle = .fullScreen
        vc.comingFrom = "pickup"
        present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTapCallBtn(_ sender: Any) {
        
        if StoreDetailsData.shared.phoneNumber.isEmpty {
            
        }else{
            let phoneNo = Int(StoreDetailsData.shared.phoneNumber)
            
            let url:URL = URL(string: "TEL://\(phoneNo!)")!
            print(phoneNo!)
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
        
    }
    
    @IBAction func onTapstoreDirectionBtn(_ sender: Any) {
        
        if StoreDetailsData.shared.storelat.isEmpty {
            
        }else{
            self.openGoogleMap(dlat: StoreDetailsData.shared.storelat, dlong: StoreDetailsData.shared.storelong)
        }
        
    }
    
    func openGoogleMap(dlat:String, dlong:String) {
        
        //pinakini evenue
        let slat = StoreDetailsData.shared.userlat
        let slong = StoreDetailsData.shared.userlong
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string:"comgooglemaps://?saddr=\(slat),\(slong)&daddr=\(dlat),\(dlong)&directionsmode=driving&zoom=14&views=traffic") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(slat),\(slong)&daddr=\(dlat),\(dlong)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
    }
    
    @IBAction func onTapContinueBtn(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            self.cartItemsData.removeAll()
            
            for i in 0..<cartlistModel!.data!.count {
                self.cartItemsData.append(["product_id": cartlistModel!.data?[i].pid ?? "", "price": cartlistModel!.data?[i].price ?? "", "weight": cartlistModel!.data?[i].productWeight ?? "", "cutting_preferances": cartlistModel!.data?[i].cid ?? "", "quantity": cartlistModel!.data?[i].quantity ?? ""])
            }
            
            if storeAddrLbl.text!.isEmpty {
                showAlertMessage(vc: self, titleStr: "", messageStr: "Select Store Location")
            }else{
                self.orderCreateApi()
            }
            
            print(cartItemsData)
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    //MARK:- API
    //Cartlist
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
                    print(responseJson.data?.count, "cart value")
                    
                    DispatchQueue.main.async {
                        self.count = responseJson.data?.count ?? 0
                        
                        if responseJson.data?.count ?? 0 > 1 {
                            self.pickupTVHeight.constant = CGFloat(118 * responseJson.data!.count)
                            self.viewHeight.constant = 540 + self.pickupTVHeight.constant
                        }
                        
                        self.pickupTV.reloadData()
                    }
                    
                }else{
                    let alert = UIAlertController(title: "", message: "Your cart is empty", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Start Fishing", style: .default, handler: { (alerts) in
                        
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
    
    //place order before payment Delivery
    func orderCreateApi() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        
        let values:[String:String] = UserDefaults.standard.value(forKey: "userdetails") as! [String : String]
        
        print(values["firstName"]!, "firstName")
        print(values["firstName"]!, "firstName")
        
        let params = [
            "product_arr":cartItemsData,
            "address_id":"",
            "payment_type":"netbanking",
            "payment_status":"",
            "order_status":"pending",
            "order_amount": CartDataStore.shared.total,
            "discount":CartDataStore.shared.couponAmount,
            "mobile":values["phone"]!,
            "txn_id":"",
            "uid":uid,
            "delivery_date":CartDataStore.shared.deliveryDate,
            "delivery_time":CartDataStore.shared.SlotsSelectedCell,
            "delivery_charge":CartDataStore.shared.deliveryCharges,
            "gst":CartDataStore.shared.gst,
            "store_id":StoreDetailsData.shared.storeID,
            "delivery_type":CartDataStore.shared.deliverType
        ] as [String : Any]
        
        print(params)
        
        RestService.serviceCall(url: createOrder_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do{
                let responseJson = try JSONDecoder().decode(PickupOrderModel.self, from: response)
                self.pickupOrderModel = responseJson
                if responseJson.status == 200 {
                    print(responseJson.orderID, "order id")
                    
                    DispatchQueue.main.async {
                        self.showPaymentForm(order_ID: responseJson.orderID)
                    }
                    
                }else{
                    showAlertMessage(vc: self, titleStr: "", messageStr: self.pickupOrderModel!.message)
                }
            }catch{
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
        
    }
    
    //paymentGateway
    func showPaymentForm(order_ID:String){
        
        let values:[String:String] = UserDefaults.standard.value(forKey: "userdetails") as! [String : String]
        
        print(values["firstName"]!, "firstName")
        
        print(CartDataStore.shared.netTotal, "netvalues")
        
        amount = Double(Float(pickupOrderModel!.netTotal) ?? (1.0)) * 100.0
        print("amount1",amount)
        let options: [String:Any] = [
            "amount": "\(amount)", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "You are purchasing the products",
            //"order_id": order_ID,
            "image": "",
            "name": "MYFishingBoat",
            "prefill": [
                "contact": values["phone"]!,
                "email": values["email"]!
            ],
            "theme": [
                "color": "#233E99"
            ]
        ]
        print(options)
        razorpay.open(options, displayController: self)
    }
    
    //Payment Status payment
    func paymentStatusAPI(orderID:String, tnxID:String, payment_Status:String, date_time:String, amount:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "order_id": orderID,
            "txn_id": tnxID,
            "payment_status": payment_Status,
            "date_time": date_time,
            "amount": amount
        ]
        
        RestService.serviceCall(url: paymentStatus_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(PaymentStatusModel.self, from: response) else{return}
            
            if responseJson.status == 200 {
                
                cartValue = ""
                homeScreenValue = ""
                cartScreenValue = ""
                cartStaticValue = ""
                
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(identifier: "PaymentSuccessVC") as! PaymentSuccessVC
                    vc.modalPresentationStyle = .fullScreen
                    vc.selectedType = "pickup"
                    UserDefaults.standard.set(orderID, forKey: "orderid")
                    self.present(vc, animated: false, completion: nil)
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Nearest Store based on address
    func pickupAvailCheck(userLat:String, userLng:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "lat": userLat,
            "lng": userLng,
            "uid": uid,
            "delivery_type": "pickup"
        ]
        
        print(params, "availability")
        
        RestService.serviceCall(url: picDelNearAddr_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self) {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(CheckPickupSummaryModel.self, from: response) else{return}
            self.checkPickupSummaryModel = responseJson
            if responseJson.status == true {
                
                let addr1 = responseJson.data?[0].landmark ?? ""
                let addr2 = responseJson.data?[0].address ?? ""
                let addr3 = responseJson.data?[0].pincode ?? ""
                let addr = addr1+" "+addr2+" "+addr3
                self.storeAddrLbl.text = addr
                self.storeNameLbl.text = responseJson.data?[0].storeName
                self.storeKmLbl.text = "\(String(describing: responseJson.data?[0].distance!.toDouble()!.rounded(toPlaces: 2))) km"
                
                StoreDetailsData.shared.storeID = responseJson.data?[0].id ?? ""
                StoreDetailsData.shared.phoneNumber = responseJson.data?[0].phone ?? ""
                StoreDetailsData.shared.storelat = responseJson.data?[0].lat ?? "0.00"
                StoreDetailsData.shared.storelong = responseJson.data?[0].lng ?? "0.00"
                
                if self.storeAddrLbl.text!.isEmpty {
                    self.changeBtn.setTitle("SELECT", for: .normal)
                }else{
                    self.changeBtn.setTitle("CHANGE", for: .normal)
                }
                
            }else{
                
                if self.storeAddrLbl.text!.isEmpty {
                    self.changeBtn.setTitle("SELECT", for: .normal)
                }else{
                    self.changeBtn.setTitle("CHANGE", for: .normal)
                }
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        } failure: { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
}

extension PickupSummaryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = pickupTV.dequeueReusableCell(withIdentifier: PickUpDelivTVCell.identifier, for: indexPath) as! PickUpDelivTVCell
        
        let items = cartlistModel!.data?[indexPath.row]
        
        cell.productImage.sd_setImage(with: URL(string: items!.image!.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!), placeholderImage: UIImage(named: ""))
        cell.productName.text = items?.productName
        cell.productDescp.text = items?.type
        cell.productPrice.text = items?.price
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension PickupSummaryVC: RazorpayPaymentCompletionProtocol {
    
    func onPaymentError(_ code: Int32, description str: String) {
        
        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm") // Set output formate
        
        print(formate)
        
        showAlertMessage(vc: self, titleStr: "Failure", messageStr: str)
        print(str)
        
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        
        print(payment_id)
        
        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy-MM-dd HH:mm") // Set output formate
        
        print(formate)
        
        paymentStatusAPI(orderID: self.pickupOrderModel!.orderID, tnxID: payment_id, payment_Status: "Success", date_time: formate, amount: "\(amount)")
        
    }
}
