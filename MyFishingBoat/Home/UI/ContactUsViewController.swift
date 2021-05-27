//
//  ContactUsViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsViewController: BaseViewController {
    
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var feedbackTV: UITextView!
    @IBOutlet weak var sendMessageBtn: UIButton!
    
    var contactusModel:ContactUsModel?
    
    var placeHolderText = "Write your queries or feedback here."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        feedbackTV.layer.cornerRadius = 10
        feedbackTV.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            feedbackTV.isUserInteractionEnabled = true
            sendMessageBtn.isUserInteractionEnabled = true
        }else{
            feedbackTV.isUserInteractionEnabled = false
            sendMessageBtn.isUserInteractionEnabled = false
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/signup to submit a query!")
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func sendMessagesAction(_ sender: Any) {
        if feedbackTV.text!.isEmpty || feedbackTV.text! == placeHolderText {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Submit your feedback")
        }else{
            if Reachability.isConnectedToNetwork(){
                print(feedbackTV.text)
//                if feedbackTV.text! == placeHolderText ||  {
//                    showAlertMessage(vc: self, titleStr: "", messageStr: "field is empty")
//                }else{
                    contactusApi()
                //}
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
        
    }
    
    func contactusApi() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
        "uid": uid,
        "discription": feedbackTV.text!
        ]
        
        RestService.serviceCall(url: contactus_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(ContactUsModel.self, from: response) else{return}
            self.contactusModel = responseJson
            
            if responseJson.status == 200 {
                self.feedbackTV.text = self.placeHolderText
                self.feedbackTV.resignFirstResponder()
                showAlertMessage(vc: self, titleStr: "", messageStr: self.contactusModel!.message)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.contactusModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension ContactUsViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        if textView.text == placeHolderText {
            textView.text = ""
        }
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView.text.isEmpty {
            textView.text = placeHolderText
        }
        textView.resignFirstResponder()
    }
    
}
