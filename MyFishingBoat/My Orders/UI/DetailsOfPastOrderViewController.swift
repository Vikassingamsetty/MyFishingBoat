//
//  DetailsOfPastOrderViewController.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 14/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class DetailsOfPastOrderViewController: UIViewController {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var noOfItemsLbl: UILabel!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var displayView: UIView!
    
    var orderNumb = String()
    
    private let collectionViews: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        let collect = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collect.backgroundColor = .white
        collect.register(HeaderCVCell.nib(), forCellWithReuseIdentifier: HeaderCVCell.identifier)
        collect.register(OrderListCVCell.nib(), forCellWithReuseIdentifier: OrderListCVCell.identifier)
        collect.register(TotalPriceCVCell.nib(), forCellWithReuseIdentifier: TotalPriceCVCell.identifier)
        collect.register(AddresshDetailsCVCell.nib(), forCellWithReuseIdentifier: AddresshDetailsCVCell.identifier)
        return collect
    }()
    
    //Models
    var pastOrderDetailsModel:PastOrderDetailsModel?
    var cout = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViews.delegate = self
        collectionViews.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            orderStatusDetailsAPI()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        displayView.addSubview(collectionViews)
        collectionViews.frame = displayView.bounds
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
    //API call
    func orderStatusDetailsAPI() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
        "uid": uid,
        "order_id": orderNumb
        ]
        
        print(params, "past orders details")
        
        RestService.serviceCall(url: viewOrderDetails_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(PastOrderDetailsModel.self, from: response) else{return}
            self.pastOrderDetailsModel = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.cout = 4
                    self.orderNumberLbl.text = responseJson.data[0].orderID
                    self.noOfItemsLbl.text = "\(responseJson.data.count)"
                    self.totalAmountLbl.text = responseJson.data[0].orderAmount
                    
                    self.collectionViews.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.pastOrderDetailsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension DetailsOfPastOrderViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
            guard let cell = collectionViews.dequeueReusableCell(withReuseIdentifier: HeaderCVCell.identifier, for: indexPath) as? HeaderCVCell else {return UICollectionViewCell()}
            
            //Need not change the below text.
            cell.orderNumberTitle.text = "ORDER STATUS"
            cell.orderNumberLbl.text = ""
            cell.orderStatuslbl.text = pastOrderDetailsModel!.data[0].orderStatus
            
            if pastOrderDetailsModel!.data[0].orderStatus == "Order_cancelled" {
                //textcolor ato red
                cell.orderStatuslbl.textColor = .red
            }
            
            return cell
            
        }else if indexPath.section == 1 {
            guard let cell = collectionViews.dequeueReusableCell(withReuseIdentifier: OrderListCVCell.identifier, for: indexPath) as? OrderListCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            
            cell.itemNameLbl.text = path.productName
            cell.totalQuantityLbl.text = "\(path.quantity ?? "")"
            cell.ratePerQty.text = "\(path.productPrice ?? "")"
            cell.quantityPerRate.text = "\(path.productWeight ?? "0")"
            cell.subTotalOfEachQuantityLbl.text = "\(Float(path.quantity ?? "0")! * Float(path.productPrice ?? "0")!)"
            
            return cell
            
        }else if indexPath.section == 2 {
            guard let cell = collectionViews.dequeueReusableCell(withReuseIdentifier: TotalPriceCVCell.identifier, for: indexPath) as? TotalPriceCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            
            cell.itemTotalLbl.text = path.orderAmount
            cell.deliveryChargedLbl.text = path.deliveryCharge
            cell.gstLbl.text = path.gst
            cell.netTotalLbl.text = path.total
            
            return cell
        }else {
            guard let cell = collectionViews.dequeueReusableCell(withReuseIdentifier: AddresshDetailsCVCell.identifier, for: indexPath) as? AddresshDetailsCVCell else {return UICollectionViewCell()}
            
            let path = pastOrderDetailsModel!.data[indexPath.row]
            cell.phoneNumberLbl.text = path.mobile
            cell.dateofDeliveryLbl.text = path.deliveryDate!+" "+path.deliveryTime!
            
            if path.deliveryType == "pickup" || path.deliveryType == "onlypickup" {
                let halfAddr = path.storename!+" "+path.stroreLandmark!
                let fullAddr = path.storeaddress!+" "+path.storePincode!
                cell.deliveredAddrLbl.text = halfAddr+" "+fullAddr
                cell.deliveryStaticLbl.text = "PICKUP FROM"
            }else{
                let halfAddr = path.flotNo!+" "+path.landMark!
                let fullAddr = path.street!+" "+path.address!+" "+path.pincode!
                cell.deliveredAddrLbl.text = halfAddr+" "+fullAddr
                cell.deliveryStaticLbl.text = "DELEVERY TO"
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
