//
//  LoginViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var backBtnOutlet: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    let button = UIButton(type: .custom)
    
    //Model
    var loginModel:LoginModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayData()
    }
    
    func displayData() {
        
        button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 5, left: -30, bottom: 5, right: 5)
        button.frame = CGRect(x: Int(passwordTxtField.frame.size.width) - 32,
                              y: 0,
                              width: 30,
                              height: 30)
        button.addTarget(self, action: #selector(passwordHideUnhideAction(sender:)), for: .touchUpInside)
        passwordTxtField.rightView = button
        passwordTxtField.rightViewMode = .always
        passwordTxtField.isSecureTextEntry = true
        
    }
    
    @objc func passwordHideUnhideAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.passwordTxtField.isSecureTextEntry = false
            button.setImage(#imageLiteral(resourceName: "unhide"), for: .normal)
        }else {
            self.passwordTxtField.isSecureTextEntry = true
            button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func loginBtnAction(_ sender: Any) {
        
        if emailTxtField.text!.isEmpty || passwordTxtField.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Email or password fields are empty")
        }else {
            if Reachability.isConnectedToNetwork() {
                userLogin()
            }else {
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        
        if emailTxtField.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "To reset password, enter email-id & click on Forget Password!")
        }else {
            if Reachability.isConnectedToNetwork() {
                userforgotPassword()
            }else {
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }
    }
    
    @IBAction func logInOTPBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendOTPViewController") as! SendOTPViewController
        self.present(vc, animated: false, completion: nil)
    }
    
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(identifier: "SignupViewController") as! SignupViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    //Mark:-API
    func userLogin() {
        
        let params = [
            "username": emailTxtField.text!,
            "password": passwordTxtField.text!,
            "ip": "12.12.12.23",
            "devicetoken": "zerxtcyuvbinom",
            "devicetype": "Android",
            "deviceid": "1234567"
        ]
        
        RestService.serviceCall(url: loginpswd_URL, method: .post, parameters: params,
                                header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true,
                                title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
                                    guard let self = self else {return}
                                    
                                    do{
                                        let responseJson = try JSONDecoder().decode(LoginModel.self, from: response)
                                        self.loginModel = responseJson
                                        
                                        if responseJson.status == 200 {
                                            
                                            UserDefaults.standard.set(responseJson.data![0].uid, forKey: "userid")
                                            print(responseJson.data![0].email)
                                            
                                            var userDetails = [String:String]()
                                            
                                            userDetails["firstName"] = responseJson.data![0].firstName
                                            userDetails["lastName"] = responseJson.data![0].lastName
                                            userDetails["email"] = responseJson.data![0].email
                                            userDetails["phone"] = responseJson.data![0].mobile
                                            userDetails["password"] = responseJson.data![0].password
                                            
                                            UserDefaults.standard.set(userDetails, forKey: "userdetails")
                                            
                                            if cartValue == "cart" {
                                                let vc = self.storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                                                self.present(vc, animated: false, completion: nil)
                                            }else{
                                                let vc = self.storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
                                                self.present(vc, animated: false, completion: nil)
                                            }
                                            
                                            UserDefaults.standard.setValue("Yes", forKey: "FromTab")
                                        }else{
                                            showAlertMessage(vc: self, titleStr: "", messageStr: self.loginModel!.message)
                                        }
                                    }catch{
                                        showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
                                    }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    func userforgotPassword() {
        
        let params = [
            "email": emailTxtField.text!
        ]
        
        RestService.serviceCall(url: forgotpswd_URL, method: .post, parameters: params,
                                header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true,
                                title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
                                    guard let self = self else {return}
                                    
                                    guard let responseJson = try? JSONDecoder().decode(LoginModel.self, from: response) else{return}
                                    if responseJson.status == 200 {
                                        print(responseJson.data![0].email)
                                        showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                                    }else{
                                        showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                                    }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }

        
    }
    
}
