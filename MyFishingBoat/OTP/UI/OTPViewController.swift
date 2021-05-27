//
//  OTPViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import Alamofire

class OTPViewController: UIViewController {
    
    @IBOutlet weak var emailtxtField: UITextField!
    @IBOutlet weak var otpTxtField: UITextField!
    @IBOutlet weak var editBtnOutlet: UIButton!
    @IBOutlet weak var resendBtnOutlet: UIButton!
    
    var mobileNumber:String?
    
    //model
    var mobileOTPModel:MobileOTPModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emailtxtField.text = mobileNumber
        emailtxtField.isUserInteractionEnabled = false
        
        editBtnOutlet.addTarget(self, action: #selector(editNumber(_:)), for: .touchUpInside)
        resendBtnOutlet.addTarget(self, action: #selector(resendOTP(_:)), for: .touchUpInside)
        
        otpTxtField.delegate = self
    }
    
    @objc private func editNumber(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc private func resendOTP(_ sender: UIButton) {
        //sendOTP(numb: emailtxtField.text!)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        if emailtxtField.text!.isEmpty || otpTxtField.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Fields are empty")
        }else {
            if Reachability.isConnectedToNetwork() {
                if otpTxtField.text!.count == 6 {
                    userLogin()
                }else{
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Only 6 digits OTP")
                }
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
        
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func loginUsingPasswordBtnAction(_ sender: Any) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        present(vc, animated: false, completion: nil)
    }
    
    //MARK:- API's
    //userLogin
    func userLogin() {
        let params = [
            //9014499997 //12345
            "mobile": emailtxtField.text!,
            "otp": otpTxtField.text!
        ]
        
        RestService.serviceCall(url: checkOTP_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            guard let responseJson = try? JSONDecoder().decode(MobileOTPModel.self, from: response) else {return}
            
            self.mobileOTPModel = responseJson
            
            if responseJson.status == 200 {
                print(responseJson.data![0].email,"OTP verification screen")
                
                var userDetails = [String:String]()
                
                userDetails["firstName"] = responseJson.data![0].firstName
                userDetails["lastName"] = responseJson.data![0].lastName
                userDetails["email"] = responseJson.data![0].email
                userDetails["phone"] = responseJson.data![0].mobile
                userDetails["password"] = responseJson.data![0].password
                
                UserDefaults.standard.set(userDetails, forKey: "userdetails")
                UserDefaults.standard.setValue("Yes", forKey: "FromTab") //back button
                UserDefaults.standard.set(responseJson.data![0].uid, forKey: "userid")
                
                if cartValue == "cart" {
                    let vc = self.storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                    self.present(vc, animated: false, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.mobileOTPModel!.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
}

extension OTPViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // get the current text, or use an empty string if that failed
        let currentText = textField.text ?? ""

        // attempt to read the range they are trying to change, or exit if we can't
        guard let stringRange = Range(range, in: currentText) else { return false }

        // add their new text to the existing text
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

        // make sure the result is under 10 characters
        return updatedText.count <= 6
    }
    
}



