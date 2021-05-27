//
//  CouponsViewController.swift
//  MyFishingBoat
//
//  Created by vikas on 05/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

protocol CouponCode {
    func getCoupon(coupon:String, amount:String)
}

class CouponsViewController: UIViewController {
    
    @IBOutlet weak var searchCouponTF: UITextField!
    @IBOutlet weak var couponTV: UITableView!
    
    var totalAmount = Int()
    
    //Model
    var couponsModel:CouponsModel?
    var delegate:CouponCode?
    var couponValidModel:CouponValidModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        couponTV.delegate = self
        couponTV.dataSource = self
        couponTV.estimatedRowHeight = couponTV.rowHeight
        couponTV.rowHeight = UITableView.automaticDimension
        
        searchCouponTF.layer.cornerRadius = 20
        searchCouponTF.layer.masksToBounds = true
        searchCouponTF.layer.borderWidth = 0
        searchCouponTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 2))
        searchCouponTF.leftViewMode = .always
        
        if Reachability.isConnectedToNetwork() {
            couponList()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    @IBAction func backBtn(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    
    func couponList() {
        RestService.serviceCall(url: coupons_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(CouponsModel.self, from: response) else{return}
            self.couponsModel = responseJson
            
            if responseJson.status == 200 {
                DispatchQueue.main.async {
                    self.couponTV.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.couponsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
    //CouponValidation
    func userCouponValid(code:String, id:String, uid:String, amount:String) {
        
        let date = Date()
        let formate = date.getFormattedDate(format: "yyyy-MM-dd")
        
        let params = [
            "id": id,
            "coup_code": code,
            "uid": uid,
            "date": formate,
            "amount": amount
        ]
        print(params)
        RestService.serviceCall(url: couponApply_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self) {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(CouponValidModel.self, from: response) else{return}
            if responseJson.status == 200 {
                self.couponValidModel = responseJson
                for i in 0..<self.couponsModel!.data!.count {
                    
                    self.delegate?.getCoupon(coupon: self.couponsModel!.data?[i].coupCode ?? "", amount: "\(self.totalAmount - Int(responseJson.data!))")
                    print(self.totalAmount - Int(responseJson.data!))
                    print(responseJson.data,"Coupon")
                    
                    self.dismiss(animated: false, completion: nil)
                    
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        } failure: { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension CouponsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = couponsModel?.data?.count {
            return count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = couponTV.dequeueReusableCell(withIdentifier: CouponsTVCell.identifier, for: indexPath) as! CouponsTVCell
        
        cell.couponCodeLbl.text = couponsModel!.data?[indexPath.row].coupCode ?? ""
        cell.descCouponLbl.text = couponsModel!.data?[indexPath.row].discription ?? ""
        cell.expiresOnLbl.text = couponsModel!.data?[indexPath.row].expDate ?? ""
        cell.totalCouponsLbl.text = ""
            
        cell.applyCouponBtn.tag = indexPath.row
        cell.applyCouponBtn.addTarget(self, action: #selector(didapplyCoupon(_:)), for: .touchUpInside)
        return cell
    }
    
    @objc func didapplyCoupon(_ sender:UIButton) {
        
        guard let model = couponsModel?.data?[sender.tag] else{return}
        
        print(model.coupCode, model.id, model.expDate, "coupon")
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            userCouponValid(code: model.coupCode ?? "", id: model.id ?? "", uid: UserDefaults.standard.string(forKey: "userid")!, amount: "\(totalAmount)")
        }else{
            userCouponValid(code: model.coupCode ?? "", id: model.id ?? "", uid: "", amount: "\(totalAmount)")
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
