//
//  ResturentOwnersViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//
import UIKit

class AboutUsViewController: BaseViewController {

    var aboutusModel:AboutUsModel?
    
    @IBOutlet weak var homeBtnOutlet: UIButton!

    @IBOutlet weak var textView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        if Reachability.isConnectedToNetwork() {
            aboutUsApi()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    func aboutUsApi() {
        RestService.serviceCall(url: aboutus_URL, method: .post, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(AboutUsModel.self, from: response) else{return}
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
