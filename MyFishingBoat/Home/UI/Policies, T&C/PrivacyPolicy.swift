//
//  PrivacyPolicy.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 03/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class PrivacyPolicy: BaseViewController {

    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        if Reachability.isConnectedToNetwork() {
            privacyApi()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }

    @IBAction func backBtnAction(_ sender: Any) {
        UserDefaults.standard.setValue("No", forKey: "FromTab")
        dismiss(animated: false, completion: nil)
    }
    
   func privacyApi() {
       RestService.serviceCall(url: privacy_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
           guard let self = self else{return}
           guard let responseJson = try? JSONDecoder().decode(PrivacyModel.self, from: response) else{return}
           if responseJson.status == 200 {
               self.textView.text = responseJson.data[0].discription
           }else{
               showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
           }
       }) { (error) in
           showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
       }
   }
    
}
