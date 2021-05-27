//
//  ProfileViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var phntxtField: UITextField!
    @IBOutlet weak var emailTxtfield: UITextField!
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var mainView:UIView!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var newPasswordTf: UITextField!
    @IBOutlet weak var newpswdView: UIView!
    @IBOutlet weak var cnfpswdView: UIView!
    @IBOutlet weak var confirmPasswordTf: UITextField!
    
    var button = UIButton(type: .custom)
    
    //Model
    var profileUpdate: UpdateProfile?
    var passwordUpdate: PasswordUpdate?
    
    var didTap = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        nameTF.isUserInteractionEnabled = false
        lastNameTF.isUserInteractionEnabled = false
        emailTxtfield.isUserInteractionEnabled = false
        phntxtField.isUserInteractionEnabled = false
        passwordTF.isUserInteractionEnabled = false
        
        passwordTF.isSecureTextEntry = true
        newPasswordTf.isHidden = true
        newpswdView.isHidden = true
        confirmPasswordTf.isHidden = true
        cnfpswdView.isHidden = true
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"FromTab") == "Yes" {
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }else{
            dismiss(animated:false)
        }
    }
    
    @IBAction func editBtnsAction(_ sender: UIButton) {
        
        let value = sender.tag
        
        switch value {
        case 50:
            print("name")
            nameTF.isUserInteractionEnabled = true
        case 60:
            print("lastname")
            lastNameTF.isUserInteractionEnabled = true
        case 70:
            print("phone")
            phntxtField.isUserInteractionEnabled = true
        case 80:
            print("email")
            emailTxtfield.isUserInteractionEnabled = true
        case 90:
            print("password")
            didTap = "Yes"
            
            passwordTF.isUserInteractionEnabled = true
            passwordTF.text = ""
            
            newPasswordTf.isHidden = false
            newpswdView.isHidden = false
            confirmPasswordTf.isHidden = false
            cnfpswdView.isHidden = false
            
        default:
            break
        }
        
    }
    
    @IBAction func passwordRest(_ sender: Any) {
        showAlertMessage(vc: self, titleStr: "", messageStr: "A mail is been sent")
    }
    
    @IBAction func saveChengesBtnAction(_ sender: Any) {
        
        if nameTF.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "First Name can not be Empty")
        }else{
            if lastNameTF.text!.isEmpty {
                showAlertMessage(vc: self, titleStr: "", messageStr: "Last Name can not be Empty")
            }else{
                if emailTxtfield.text!.isEmpty {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Email can not be Empty")
                }else{
                    if phntxtField.text!.isEmpty {
                        showAlertMessage(vc: self, titleStr: "", messageStr: "Phone Number can not be Empty")
                    }else{
                        if passwordTF.text!.isEmpty {
                            showAlertMessage(vc: self, titleStr: "", messageStr: "Password can not be Empty")
                        }else{
                            if isValidEmail(email: emailTxtfield.text!) {
                                if Reachability.isConnectedToNetwork() {
                                    
                                    if didTap == "Yes" {
                                        
                                        if confirmPasswordTf.text!.isEmpty || newPasswordTf.text!.isEmpty || passwordTF.text!.isEmpty {
                                            showAlertMessage(vc: self, titleStr: "", messageStr: "Password fields are empty")
                                        }else{
                                            if newPasswordTf.text! != confirmPasswordTf.text! {
                                                showAlertMessage(vc: self, titleStr: "", messageStr: "New password and Confirm Password must be same")
                                            }else{
                                                userPasswordChange()
                                            }
                                        }
                                    }else{
                                        userUpdateProfile()
                                    }
                                    
                                    
                                }else {
                                    showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
                                }
                            }else{
                                showAlertMessage(vc: self, titleStr: "", messageStr: "Invalid Email format!!")
                            }
                        }
                    }
                }
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nameTF.isUserInteractionEnabled = false
        emailTxtfield.isUserInteractionEnabled = false
        phntxtField.isUserInteractionEnabled = false
        lastNameTF.isUserInteractionEnabled = false
        passwordTF.isUserInteractionEnabled = false
        
        self.newPasswordTf.isHidden = true
        self.newpswdView.isHidden = true
        self.confirmPasswordTf.isHidden = true
        self.cnfpswdView.isHidden = true
        
//        let values:[String:String] = UserDefaults.standard.value(forKey: "userdetails") as! [String : String]
//
//        nameTF.text = values["firstName"]!
//        lastNameTF.text = values["lastName"]!
//        emailTxtfield.text = values["email"]!
//        phntxtField.text = values["phone"]!
//        passwordTF.text = values["password"]!
        
        
        if Reachability.isConnectedToNetwork() {
            
            if UserDefaults.standard.string(forKey: "userid") != nil {
                
                let values:[String:String] = UserDefaults.standard.value(forKey: "userdetails") as! [String : String]
                
                nameTF.text = values["firstName"]!
                lastNameTF.text = values["lastName"]!
                emailTxtfield.text = values["email"]!
                phntxtField.text = values["phone"]!
                passwordTF.text = values["password"]!
                
            }else {
                let vc = storyboard?.instantiateViewController(identifier: "BeforeLoginVC") as! BeforeLoginVC
                addChild(vc)
                mainView.addSubview(vc.view)
                vc.view.frame = mainView.frame
                vc.didMove(toParent: self)
            }
        }else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    
    //MARK:- Server calls
    //customer details update
    func userUpdateProfile() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "first_name": nameTF.text!,
            "last_name": lastNameTF.text!,
            "email": emailTxtfield.text!,
            "mobile": phntxtField.text!,
            "uid": uid
        ]
        
        RestService.serviceCall(url: updateProfile_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(UpdateProfile.self, from: response) else{return}
            
            if responseJson.status == 200 {
                
                var userDetails = [String:String]()
                
                userDetails["firstName"] = responseJson.data?[0].firstName ?? ""
                userDetails["lastName"] = responseJson.data?[0].lastName ?? ""
                userDetails["email"] = responseJson.data?[0].email ?? ""
                userDetails["phone"] = responseJson.data?[0].mobile ?? ""
                userDetails["password"] = responseJson.data?[0].password ?? ""
                
                UserDefaults.standard.set(userDetails, forKey: "userdetails")
                
                //making TF non editable
                self.nameTF.isUserInteractionEnabled = false
                self.lastNameTF.isUserInteractionEnabled = false
                self.emailTxtfield.isUserInteractionEnabled = false
                self.phntxtField.isUserInteractionEnabled = false
                self.lastNameTF.isUserInteractionEnabled = false
                
                self.newPasswordTf.isHidden = true
                self.newpswdView.isHidden = true
                self.confirmPasswordTf.isHidden = true
                self.cnfpswdView.isHidden = true
                
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
    
    func userPasswordChange() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "email": emailTxtfield.text!,
            "uid": uid,
            "password": newPasswordTf.text!,
            "cpassword": confirmPasswordTf.text!,
            "curentpassword": passwordTF.text!
        ]
        
        RestService.serviceCall(url: changePswd_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(PasswordUpdate.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.didTap = ""
                //making TF non editable
                self.nameTF.isUserInteractionEnabled = false
                self.emailTxtfield.isUserInteractionEnabled = false
                self.phntxtField.isUserInteractionEnabled = false
                self.lastNameTF.isUserInteractionEnabled = false
                self.passwordTF.isUserInteractionEnabled = false
                
                self.newPasswordTf.isHidden = true
                self.newpswdView.isHidden = true
                self.confirmPasswordTf.isHidden = true
                self.cnfpswdView.isHidden = true
                
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    // Regular expression for Email-ID
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
}


