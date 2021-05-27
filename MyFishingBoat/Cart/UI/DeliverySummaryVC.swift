//
//  DeliverySummaryVC.swift
//  MyFishingBoat
//
//  Created by vikas on 06/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import Razorpay

class DeliverySummaryVC: BaseViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var deliveryTV: UITableView!
    @IBOutlet weak var deliveryTvHeight: NSLayoutConstraint!
    @IBOutlet weak var deliveryAddrLbl: UILabel!
    @IBOutlet weak var itemTotalLbl: UILabel!
    @IBOutlet weak var delryChrgLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel! 
    @IBOutlet weak var netTotalLbl: UILabel!
    @IBOutlet weak var changeBtn: CustomButton!
    @IBOutlet weak var viewHeight: NSLayoutConstraint!
    
    
    //Model
    var cartlistModel:CartListModel?
    var deliveryOrderModel:DeliveryOrderModel?
    var checkDeliverySummaryModel:CheckDeliverySummaryModel?
    
    //Payment
    var razorpay: RazorpayCheckout!
    
    //TV count
    var count = Int()
    
    //Pickingup address
    var addrID = String()
    var deliveryAddress = String()
    
    //get values from cart
    var cartItemsData = [[String:String]]()
    
    var amount = Double()
    
    var comingFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        deliveryTV.delegate = self
        deliveryTV.dataSource = self
        deliveryTV.register(PickUpDelivTVCell.nib(), forCellReuseIdentifier: PickUpDelivTVCell.identifier)
        deliveryTV.estimatedRowHeight = 118
        deliveryTV.rowHeight = UITableView.automaticDimension
        
        
        itemTotalLbl.text = CartDataStore.shared.total
        delryChrgLbl.text = CartDataStore.shared.deliveryCharges
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
            
            deliveryAddrLbl.text = AddrDetailsData.shared.userAddress
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        if deliveryAddrLbl.text!.isEmpty {
            changeBtn.setTitle("SELECT", for: .normal)
        }else{
            changeBtn.setTitle("CHANGE", for: .normal)
        }
        
    }
    
    //MARK:- selector
    @IBAction func onTapDeliveryChange(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
        vc.modalPresentationStyle = .fullScreen
        vc.isFrom = "deliverySummary"
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func onTapBackBtn(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func onTapContinueBtn(_ sender: Any) {
        
        if Reachability.isConnectedToNetwork() {
            self.cartItemsData.removeAll()
            
            for i in 0..<cartlistModel!.data!.count {
                self.cartItemsData.append(["product_id": cartlistModel!.data?[i].pid ?? "", "price": cartlistModel!.data?[i].price ?? "", "weight": cartlistModel!.data?[i].productWeight ?? "", "cutting_preferances": cartlistModel!.data?[i].cid ?? "", "quantity": cartlistModel!.data?[i].quantity ?? ""])
            }
            
            if deliveryAddrLbl.text!.isEmpty {
                showAlertMessage(vc: self, titleStr: "", messageStr: "Select Address")
            }else{
                orderCreateApi()
            }
            
            print(cartItemsData)
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    //MARK:- API
    //cart list
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
                            self.deliveryTvHeight.constant = CGFloat(118 * responseJson.data!.count ?? 0)
                            self.viewHeight.constant = 520 + self.deliveryTvHeight.constant
                        }
                        
                        self.deliveryTV.reloadData()
                    }
                    
                }else{
                    let alert = UIAlertController(title: "Cart", message: "Your cart is empty", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Continue Fishing", style: .default, handler: { (alerts) in
                        
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
        let values:[String:String] = UserDefaults.standard.value(forKey: "userdetails") as! [String : String]
        
        print(values["firstName"]!, "firstName")
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "product_arr":cartItemsData,
            "address_id":AddrDetailsData.shared.addrID,
            "payment_type":"netbanking",
            "payment_status":"",
            "order_status":"pending",
            "order_amount": CartDataStore.shared.total,
            "discount": CartDataStore.shared.couponAmount,
            "mobile":values["phone"]!,
            "txn_id":"",
            "uid":uid,
            "delivery_date":CartDataStore.shared.deliveryDate,
            "delivery_time":CartDataStore.shared.SlotsSelectedCell,
            "delivery_charge":CartDataStore.shared.deliveryCharges,
            "gst":CartDataStore.shared.gst,
            "store_id":"",
            "delivery_type":CartDataStore.shared.deliverType
        ] as [String : Any]
        
        print(params, "create")
        
        RestService.serviceCall(url: createOrder_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do{
                let responseJson = try JSONDecoder().decode(DeliveryOrderModel.self, from: response)
                self.deliveryOrderModel = responseJson
                if responseJson.status == 200 {
                    print(responseJson.orderID, "order id")
                    
                    DispatchQueue.main.async {
                        self.showPaymentForm(order_ID: responseJson.orderID)
                    }
                    
                }else{
                    showAlertMessage(vc: self, titleStr: "", messageStr: self.deliveryOrderModel!.message)
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
        
        print(CartDataStore.shared.netTotal, "netvalues")
        
        amount = Double(Float(deliveryOrderModel!.netTotal) ?? (1.0)) * 100.0
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
    
    //payment status of success
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
                    vc.selectedType = "delivery"
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
    func deliveryAvailCheck(userLat:String, userLng:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "lat": userLat,
            "lng": userLng,
            "uid": uid,
            "delivery_type": "delivery"
        ]
        print(params, "availability")
        RestService.serviceCall(url: picDelNearAddr_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self) {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(CheckDeliverySummaryModel.self, from: response) else{return}
            self.checkDeliverySummaryModel = responseJson
            if responseJson.status == true {
                
                let info = responseJson.data?[0]
                
                let addr1 = info?.flotNo ?? ""
                let addr2 = info?.landMark ?? ""
                let addr3 = info?.street ?? ""
                let addr4 = info?.address ?? ""
                let addr5 = info?.pincode ?? ""
                
                let full1 = addr1+" "+addr2+" "+addr3
                let full2 = addr4+" "+addr5
                let addr = full1+" "+full2
                self.deliveryAddrLbl.text = addr
                self.addrID = responseJson.data?[0].id ?? ""
                
                if self.deliveryAddrLbl.text!.isEmpty {
                    self.changeBtn.setTitle("SELECT", for: .normal)
                }else{
                    self.changeBtn.setTitle("CHANGE", for: .normal)
                }
                
            }else{
                if self.deliveryAddrLbl.text!.isEmpty {
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

//Mark:- extension
extension DeliverySummaryVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = deliveryTV.dequeueReusableCell(withIdentifier: PickUpDelivTVCell.identifier, for: indexPath) as! PickUpDelivTVCell
        
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

extension DeliverySummaryVC: RazorpayPaymentCompletionProtocol {
    
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
        
        paymentStatusAPI(orderID: self.deliveryOrderModel!.orderID, tnxID: payment_id, payment_Status: "Success", date_time: formate, amount: "\(amount)")
        
    }
}
