//
//  OrderConfirmationViewController.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 14/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: BaseViewController {

    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var viewOrderDetailsBtn: UIButton!
    @IBOutlet weak var checkOrderStatusBtn: UIButton!
    @IBOutlet weak var continueShoppingBtn: UIButton!
    @IBOutlet weak var deliveryToLbl: UILabel!
    @IBOutlet weak var deliveryToAddress: UILabel!
    
    var selectedIndex = ""
    
    //Model
    var orderConfirmationModel:OrderConfirmationModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        viewOrderDetailsBtn.buttonChange(cornerRadius: 12, borderColor: #colorLiteral(red: 0.2823529412, green: 0.2862745098, blue: 0.2941176471, alpha: 1), borderWidth: 1)
        checkOrderStatusBtn.buttonChange(cornerRadius: 25, borderColor: #colorLiteral(red: 0.2823529412, green: 0.2862745098, blue: 0.2941176471, alpha: 1), borderWidth: 1)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            orderDetails()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }

    @IBAction func viewOrderDetailsBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: {
            vc.segmentController.selectedSegmentIndex = 1
            vc.segmentController.changeUnderlinePosition()
            vc.segmentControllerAction(self)
        })
    }
    
    @IBAction func checkOrderStatusBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
        vc.modalPresentationStyle = .fullScreen
        //need to add for pickup or delivery for status
        self.present(vc, animated: false)
        
    }
    
    @IBAction func continueShoppingBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: false)
    }
    
    //MARK:- API's
    func orderDetails() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        guard let id = UserDefaults.standard.string(forKey: "orderid") else{return}
        
        let params = [
            "uid": uid,
            "order_id": id
        ]
        
        RestService.serviceCall(url: orderDetails_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(OrderConfirmationModel.self, from: response) else{return}
            self.orderConfirmationModel = responseJson
            if responseJson.status == 200 {
                
                let info = responseJson.data[0]
                
                if self.selectedIndex == "delivery" {
                    let addr1 = info.userFlotno ?? ""
                    let addr2 = info.userLandMark ?? ""
                    let addr3 = info.userStreet ?? ""
                    let addr4 = info.userAddress ?? ""
                    let addr5 = info.userPincode ?? ""
                    
                    let full1 = addr1+" "+addr2+" "+addr3
                    let full2 = addr4+" "+addr5
                    let addr = full1+" "+full2
                    self.deliveryToAddress.text = addr
                }else {
                    let addr1 = info.storename ?? ""
                    let addr2 = info.stroreLandmark ?? ""
                    let addr3 = info.storeaddress ?? ""
                    let addr4 = info.storePincode ?? ""
                    
                    let full1 = addr1+" "+addr2
                    let full2 = addr3+" "+addr4
                    let addr = full1+" "+full2
                    self.deliveryToLbl.text = "PICKUP FROM"
                    self.deliveryToAddress.text = addr
                }
                
                self.totalAmountLbl.text = "\(info.total ?? "")"
                self.orderNumberLbl.text = UserDefaults.standard.string(forKey: "orderid")!
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.orderConfirmationModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }

}

