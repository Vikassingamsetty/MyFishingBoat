//
//  SignupViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    
    @IBOutlet weak var firstNameTF: UITextField!
    @IBOutlet weak var lastNameTF: UITextField!
    @IBOutlet weak var emailIdTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    @IBOutlet weak var confirmPasswordTF: UITextField!
    @IBOutlet weak var phoneNumberTF: UITextField!
    
    var button = UIButton(type: .custom)
    var button1 = UIButton(type: .custom)
    
    //Model
    var signupModel:SignUpModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayViewInfo()
    }
    
    func displayViewInfo() {
        
        button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 1, left: -30, bottom: 1, right: 5)
        button.frame = CGRect(x: Int(passwordTF.frame.size.width) - 32,
                              y: 0,
                              width: 30,
                              height: 30)
        button.addTarget(self, action: #selector(passwordHideUnhideAction(sender:)), for: .touchUpInside)
        passwordTF.rightView = button
        passwordTF.rightViewMode = .always
        passwordTF.isSecureTextEntry = true
        
        button1.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        button1.imageEdgeInsets = UIEdgeInsets(top: 1, left: -30, bottom: 1, right: 5)
        button1.frame = CGRect(x: Int(confirmPasswordTF.frame.size.width) - 32,
                              y: 0,
                              width: 30,
                              height: 30)
        button1.addTarget(self, action: #selector(pswdHideUnhideAction(sender:)), for: .touchUpInside)
        confirmPasswordTF.rightView = button1
        confirmPasswordTF.rightViewMode = .always
        confirmPasswordTF.isSecureTextEntry = true
        
        firstNameTF.becomeFirstResponder()
        
        phoneNumberTF.delegate = self
        
    }
    
    @objc func passwordHideUnhideAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.passwordTF.isSecureTextEntry = false
            button.setImage(#imageLiteral(resourceName: "unhide"), for: .normal)
        }else {
            self.passwordTF.isSecureTextEntry = true
            button.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        }
    }
    
    @objc func pswdHideUnhideAction(sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if sender.isSelected {
            self.confirmPasswordTF.isSecureTextEntry = false
            button1.setImage(#imageLiteral(resourceName: "unhide"), for: .normal)
        }else {
            self.confirmPasswordTF.isSecureTextEntry = true
            button1.setImage(#imageLiteral(resourceName: "hide"), for: .normal)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpBtnAction(_ sender: Any) {
        
        if firstNameTF.text!.isEmpty && lastNameTF.text!.isEmpty && emailIdTF.text!.isEmpty && passwordTF.text!.isEmpty && confirmPasswordTF.text!.isEmpty && phoneNumberTF.text!.isEmpty {
            
            showAlertMessage(vc: self, titleStr: "", messageStr: "Fields are empty")
            
        }else{
            if firstNameTF.text!.isEmpty {
                showAlertMessage(vc: self, titleStr: "", messageStr: "First Name can not be Empty")
            }else{
                if lastNameTF.text!.isEmpty {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Last Name can not be Empty")
                }else{
                    if emailIdTF.text!.isEmpty {
                        showAlertMessage(vc: self, titleStr: "", messageStr: "Email can not be Empty")
                    }else{
                        if passwordTF.text!.isEmpty {
                            showAlertMessage(vc: self, titleStr: "", messageStr: "Password can not be Empty")
                        }else{
                            if phoneNumberTF.text!.isEmpty {
                                showAlertMessage(vc: self, titleStr: "", messageStr: "Phone Number can not be Empty")
                            }else{
                                if confirmPasswordTF.text!.isEmpty {
                                    showAlertMessage(vc: self, titleStr: "", messageStr: "Confirm Password can not be Empty")
                                }else{
                                    if isValidEmail(email: emailIdTF.text!) {
                                        if isValidPhone(testStr: phoneNumberTF.text!) {
                                            if Reachability.isConnectedToNetwork() {
                                                
                                                if passwordTF.text!.elementsEqual(confirmPasswordTF.text!) {
                                                    userSignUp()
                                                }else {
                                                    showAlertMessage(vc: self, titleStr: "", messageStr: "Passwords do not match.")
                                                }
                                            }else {
                                                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
                                            }
                                            
                                        }else{
                                            showAlertMessage(vc: self, titleStr: "", messageStr: "Enter a valid 10 digit mobile number")
                                        }
                                    }else{
                                        showAlertMessage(vc: self, titleStr: "", messageStr: "Email-Id format is incorrect")
                                    }
                                }
                            }
                        }
                    }
                }
            }
           
        }
        
    }
    
    @IBAction func logInBtnAction(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SendOTPViewController") as! SendOTPViewController
        self.present(vc, animated:false, completion:nil)
    }
    
    //SignUp
    func userSignUp() {
        
        let params = [
            "first_name": firstNameTF.text!,
            "last_name": lastNameTF.text!,
            "email": emailIdTF.text!,
            "mobile": phoneNumberTF.text!,
            "password": passwordTF.text!,
            "ip": "12.12.12.23",
            "devicetoken": "zerxtcyuvbinom",
            "devicetype": "iOS",
            "deviceid": "1234567"
        ]
         
        print(params)
        
        RestService.serviceCall(url: register_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            do{
                let responseJson = try JSONDecoder().decode(SignUpModel.self, from: response)
                self.signupModel = responseJson
                if responseJson.status == 200 {
                    UserDefaults.standard.set(responseJson.date?.uid, forKey: "userid")
                    
                    var userDetails = [String:String]()
                    
                    userDetails["firstName"] = responseJson.date?.firstName
                    userDetails["lastName"] = responseJson.date?.lastName
                    userDetails["email"] = responseJson.date?.email
                    userDetails["phone"] = responseJson.date?.mobile
                    userDetails["password"] = responseJson.date?.password
                    
                    UserDefaults.standard.set(userDetails, forKey: "userdetails")
                    UserDefaults.standard.setValue("Yes", forKey: "FromTab")
                    
                    if cartValue == "cart" {
                        let vc = self.storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                        self.present(vc, animated: false, completion: nil)
                    }else{
                        let vc = self.storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
                        self.present(vc, animated: false, completion: nil)
                    }
                }else{
                    print(responseJson.message, "json")
                    showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                }
            }catch{
                print(error.localizedDescription, "error")
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
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

    //Reguar expression for phone
    func validate(phone: String) -> Bool {
        let PHONE_REGEX = "^\\d{3}\\d{3}\\d{4}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        let result = phoneTest.evaluate(with: phone)
        return result
    }
    
    //phone number validation INd
    func isValidPhone(testStr:String) -> Bool {
        let phoneRegEx = "^[6-9]\\d{9}$"
        var phoneNumber = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return phoneNumber.evaluate(with: testStr)
    }
   
}

extension SignupViewController: UITextFieldDelegate {
    
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
