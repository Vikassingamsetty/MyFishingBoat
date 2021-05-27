//
//  StoreAvailabilityVC.swift
//  MyFishingBoat
//
//  Created by vikas on 12/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class StoreAvailabilityVC: UIViewController {
    
    @IBOutlet weak var nonServiceable: UIView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nearStoreBtn: UIButton!
    @IBOutlet weak var serviceable: UIView!
    @IBOutlet weak var pickupView: UIView!
    @IBOutlet weak var deliveryView: UIView!
    
    var serviceType = String()
    var storeId = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nearStoreBtn.layer.cornerRadius = 12
        pickupView.layer.cornerRadius = 12
        deliveryView.layer.cornerRadius = 12
        
        displayViews()
        
    }
    
    func displayViews() {
        
        deliveryView.backgroundColor = .white
        pickupView.backgroundColor = .white
        
        serviceable.isHidden = false
        nonServiceable.isHidden = true
        
//        if serviceType == "nonservice" {
//            nonServiceable.isHidden = false
//            serviceable.isHidden = true
//        }else{
//            serviceable.isHidden = false
//            nonServiceable.isHidden = true
//        }
        
    }
    
    @IBAction func nearStoreBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
        vc.modalPresentationStyle = .fullScreen
        UserDefaults.standard.set("pickup", forKey: "deliveryType")
        
        if UserDefaults.standard.string(forKey:"userid") != nil {
            //feedbackStatus()
        }else{
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    //Pickup
    @IBAction func onTapPickup(_ sender: Any) {
        pickupView.backgroundColor = .lightGray
        deliveryView.backgroundColor = .white
        print("pickup clicked")
        UserDefaults.standard.set("pickup", forKey: "deliveryType")
        
        homeScreenValue = "pickup"
        
        if UserDefaults.standard.string(forKey:"userid") != nil {
            feedbackStatus()
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
            vc.modalPresentationStyle = .fullScreen
            cartStaticValue = ""
            UserDefaults.standard.set("pickup", forKey: "deliveryType")
            present(vc, animated: false, completion: nil)
        }
        
    }
    
    //Delivery
    @IBAction func onTapDelivery(_ sender: Any) {
        deliveryView.backgroundColor = .lightGray
        pickupView.backgroundColor = .white
        print("delivery clicked")
        UserDefaults.standard.set("delivery", forKey: "deliveryType")
        
        homeScreenValue = "delivery"
        
        if UserDefaults.standard.string(forKey:"userid") != nil {
            feedbackStatus()
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "DeliveryAddrListVC") as! DeliveryAddrListVC
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
        
    }
    
    //Check rating status of order
      func feedbackStatus() {
          
          guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
          
          let params = [
              "uid": uid
          ]
          
          RestService.serviceCall(url: feedbackStatus_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
              guard let self = self else{return}
              
              guard let responseJson = try? JSONDecoder().decode(CheckFeedbackModel.self, from: response) else{return}
            
            let delType = UserDefaults.standard.string(forKey: "deliveryType")!
            print(delType)
            
              if responseJson.status == 200 {
                  
                if responseJson.orderStatus == "Order_Delivered" || responseJson.orderStatus == "Order_Pickuped" {
                    
                    if responseJson.data![0].status == "No" {
                        
                        let storyboard = UIStoryboard(name: "Main", bundle: nil)
                        let vc = storyboard.instantiateViewController(identifier: "FeedbackViewController") as! FeedbackViewController
                        vc.modalPresentationStyle = .overCurrentContext
                        vc.orderID = responseJson.data![0].orderID
                        self.present(vc, animated: false, completion: nil)
                        
                    }else{
                        if delType == "delivery" {
                            let vc = self.storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                        }else{
                            let vc = self.storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
                            vc.modalPresentationStyle = .fullScreen
                            self.present(vc, animated: true, completion: nil)
                            
                        }
                    }
                  }else{
                    if delType == "delivery" {
                        let vc = self.storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
                        vc.modalPresentationStyle = .fullScreen
                        self.present(vc, animated: true, completion: nil)
                        
                    }
                  }
              }else{
                
                if delType == "delivery" {
                    let vc = self.storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                    
                }
                  showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
              }
          }) { (error) in
              showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
          }
          
      }
    
}
