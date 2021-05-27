//
//  PaymentSuccessVC.swift
//  MyFishingBoat
//
//  Created by vikas on 13/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class PaymentSuccessVC: UIViewController {

    var selectedType = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        CartDataStore.shared.deliverType = ""
        CartDataStore.shared.SlotsSelectedCell = ""
        CartDataStore.shared.deliveryDate = ""
        CartDataStore.shared.total = ""
        CartDataStore.shared.deliveryCharges = ""
        CartDataStore.shared.gst = ""
        CartDataStore.shared.netTotal = ""
        
        StoreDetailsData.shared.storeID = ""
        StoreDetailsData.shared.storeName = ""
        StoreDetailsData.shared.storeAddress = ""
        StoreDetailsData.shared.km = ""
        StoreDetailsData.shared.phoneNumber = ""
        StoreDetailsData.shared.userlat = ""
        StoreDetailsData.shared.userlong = ""
        StoreDetailsData.shared.storelat = ""
        StoreDetailsData.shared.storelong = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now()+6) {
            let vc = self.storyboard?.instantiateViewController(identifier: "OrderConfirmationViewController") as! OrderConfirmationViewController
            vc.modalPresentationStyle = .fullScreen
            vc.selectedIndex = self.selectedType
            self.present(vc, animated: false, completion: nil)
        }
        
    }
    
}
