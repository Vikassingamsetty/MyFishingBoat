//
//  TermsAndConditions.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 03/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class TermsAndConditions: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            termsConditionsApi()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        // Do any additional setup after loading the view.
    }

    @IBAction func backBtn(_ sender: Any) {
        UserDefaults.standard.setValue("No", forKey: "FromTab")
        dismiss(animated: false, completion: nil)
    }
    
    func termsConditionsApi() {
        RestService.serviceCall(url: termsCond_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(TCModel.self, from: response) else{return}
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
