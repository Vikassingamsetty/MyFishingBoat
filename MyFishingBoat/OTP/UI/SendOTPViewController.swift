//
//  SendOTPViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class SendOTPViewController: UIViewController {
    
    @IBOutlet weak var mobileNumberTF: UITextField!
    
    //Model
    var mobileOTPModel:MobileOTPModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mobileNumberTF.delegate = self
        
    }
    
    @IBAction func sendOTPBtnAction(_ sender: Any) {
        
        if mobileNumberTF.text!.isEmpty {
            
            showAlertMessage(vc: self, titleStr: "", messageStr: "Enter registered mobile number")
        }else {
            
            if Reachability.isConnectedToNetwork() {
                userOtpValidate()
                
                //                let vc = storyboard?.instantiateViewController(identifier: "DeliverySummaryVC") as! DeliverySummaryVC
                //                vc.modalPresentationStyle = .fullScreen
                //                present(vc, animated: false, completion: nil)
                
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
        
    }
    
    @IBAction func logInUsingPasswordBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
        
    }
    
    func userOtpValidate() {
        
        let params = [
            "mobile": mobileNumberTF.text!,
            "device_type": "ios",
            "device_token": "qwertyuioplvjhjhgvg",
            "device_id": "12345678",
            "ip": "123.2.3.2"
        ]
        
        RestService.serviceCall(url: sendOTP_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            guard let responseJson = try? JSONDecoder().decode(MobileOTPModel.self, from: response) else {return}
            self.mobileOTPModel = responseJson
            
            if responseJson.status == 200 {
                print(responseJson.data![0].uid,"OTP screen")
                
                let vc = self.storyboard?.instantiateViewController(identifier: "OTPViewController") as! OTPViewController
                vc.mobileNumber = self.mobileNumberTF.text
                self.present(vc, animated: false, completion: nil)
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.mobileOTPModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension SendOTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 10 characters
        return updatedText.count <= 10
    }
    
}
