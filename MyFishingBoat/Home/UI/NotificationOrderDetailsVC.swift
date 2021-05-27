//
//  NotificationOrderDetailsVC.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class NotificationOrderDetailsVC: UIViewController {
    
    private let collectView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .white
        return collect
    }()
    
    //Model
    var pastOrderDetailsModel:PastOrderDetailsModel?
    
    var cout = 0
    var numb = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectView.delegate = self
        collectView.dataSource = self
        collectView.register(HeaderCVCell.nib(), forCellWithReuseIdentifier: HeaderCVCell.identifier)
        collectView.register(OrderListCVCell.nib(), forCellWithReuseIdentifier: OrderListCVCell.identifier)
        collectView.register(TotalPriceCVCell.nib(), forCellWithReuseIdentifier: TotalPriceCVCell.identifier)
        collectView.register(AddresshDetailsCVCell.nib(), forCellWithReuseIdentifier: AddresshDetailsCVCell.identifier)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            if UserDefaults.standard.string(forKey: "orderid") != nil {
                orderStatusDetailsAPI()
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "No Order Details")
            }
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        view.addSubview(collectView)
        collectView.frame = view.bounds
    }
    
    //API call
    func orderStatusDetailsAPI() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "order_id": UserDefaults.standard.string(forKey: "orderid")!
        ]
        
        RestService.serviceCall(url: viewOrderDetails_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(PastOrderDetailsModel.self, from: response) else{return}
            self.pastOrderDetailsModel = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.cout = 4
                    self.collectView.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.pastOrderDetailsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension NotificationOrderDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return cout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if section == 0 {
            return 1
        }else if section == 1 {
            return pastOrderDetailsModel!.data.count
        }else if section == 2 {
            return 1
        }else {
            return 1
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: HeaderCVCell.identifier, for: indexPath) as? HeaderCVCell else {return UICollectionViewCell()}
            cell.orderNumberLbl.text = pastOrderDetailsModel!.data[0].orderID
            cell.orderStatuslbl.text = ""
            return cell
            
        }else if indexPath.section == 1 {
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: OrderListCVCell.identifier, for: indexPath) as? OrderListCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            
            cell.itemNameLbl.text = path.productName ?? ""
            cell.totalQuantityLbl.text = "\(path.quantity ?? "")"
            cell.ratePerQty.text = "\(path.productPrice ?? "")"
            cell.quantityPerRate.text = "\(path.productWeight ?? "0")"
            cell.subTotalOfEachQuantityLbl.text = "\(Float(path.quantity ?? "0")! * Float(path.productPrice ?? "0")!)"
            return cell
            
        }else if indexPath.section == 2 {
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: TotalPriceCVCell.identifier, for: indexPath) as? TotalPriceCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            
            cell.itemTotalLbl.text = path.orderAmount
            cell.deliveryChargedLbl.text = path.deliveryCharge
            cell.gstLbl.text = path.gst
            cell.netTotalLbl.text = path.total
            
            return cell
            
        }else {
            guard let cell = collectView.dequeueReusableCell(withReuseIdentifier: AddresshDetailsCVCell.identifier, for: indexPath) as? AddresshDetailsCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            
            cell.phoneNumberLbl.text = path.mobile
            cell.dateofDeliveryLbl.text = path.deliveryDate
            
            if path.deliveryType == "pickup" || path.deliveryType == "onlypickup" {
                let halfaddr = path.storename!+" "+path.stroreLandmark!
                let fullAddr = path.storeaddress!+" "+path.storePincode!
                cell.deliveredAddrLbl.text = halfaddr+" "+fullAddr
                cell.deliveryStaticLbl.text = "PICKUP FROM"
            }else{
                let halfaddr = path.flotNo!+" "+path.landMark!
                let fullAddr = path.street!+" "+path.address!+" "+path.pincode!
                cell.deliveredAddrLbl.text = halfaddr+" "+fullAddr
                cell.deliveryStaticLbl.text = "DELIVERED TO"
            }
            
            cell.paymentTypeLbl.text = path.paymentType
            
            return cell
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            return CGSize(width: view.frame.size.width, height: 102)
        }else if indexPath.section == 1 {
            return CGSize(width: view.frame.size.width, height: 54)
        }else if indexPath.section == 2 {
            return CGSize(width: view.frame.size.width, height: 139)
        }else {
            return CGSize(width: view.frame.size.width, height: 210)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
