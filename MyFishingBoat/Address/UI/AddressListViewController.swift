//
//  AddressListViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import CoreLocation


class AddressListViewController: BaseViewController, UITextFieldDelegate {
    
    //Model
    var customerDetailsID: CustomerDetailsID?
    var addrListModel:AddressListModel?
    var deliveryAvailabilityAddr:DeliveryAvailabilityAddr?
    
    //address string
    var count = Int()
    var fullAddr = String()
    var isFrom = ""
    
    //HIde unhide storeAddrBtn
    var isHiding = ""
    
    //Google maps
    private var locationManager:CLLocationManager?
    private var marker = GMSMarker()
    //lat and long storage
    var latValue:Double?
    var longValue:Double?
    
    @IBOutlet weak var addressTableView: UITableView!
    @IBOutlet weak var menuBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            userAddrList()
        }else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        addressTableView.estimatedRowHeight = addressTableView.rowHeight
        addressTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            userAddrList()
            getUserLocation()
        }else {
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
    //MARK:- getting location
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        locationManager?.allowsBackgroundLocationUpdates = false
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.startUpdatingLocation()
        }
        
    }
    
    @objc func editAction(sender: UIButton){
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "NewAddressAddViewController") as! NewAddressAddViewController
        
        vc.tappedOn = "edit"
        vc.editTag = addrListModel!.data?[sender.tag].id ?? ""
        vc.areaName = addrListModel!.data?[sender.tag].address ?? ""
        vc.streetName = addrListModel!.data?[sender.tag].street ?? ""
        vc.addrType = addrListModel!.data?[sender.tag].addressType ?? ""
        vc.flatNo = addrListModel!.data?[sender.tag].flotNo ?? ""
        vc.landmark = addrListModel!.data?[sender.tag].landMark ?? ""
        vc.pincode = addrListModel!.data?[sender.tag].pincode ?? ""
        vc.latValue = Double("\(String(describing: addrListModel!.data?[sender.tag].ltd ?? ""))") ?? 0.000
        vc.longValue = Double("\(String(describing: addrListModel!.data?[sender.tag].lng ?? ""))") ?? 0.000
        
        self.present(vc, animated: false, completion: nil)
    }
    
    @objc func deleteAction(sender: UIButton){
        
        guard let id = UserDefaults.standard.string(forKey: "userid") else {return}
        print(addrListModel!.data?[sender.tag].id, "id nom")
        let params = [
            "id":addrListModel!.data?[sender.tag].id ?? "",
            "uid":id
        ]
        
        RestService.serviceCall(url: deleteaddr_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: { (response) in
            
            guard let responseJson = try? JSONDecoder().decode(DeleteAddrModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                
                self.userAddrList()
                self.addressTableView.reloadData()
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
    //MARK:-APi
    //Address list
    func userAddrList() {
        
        self.fullAddr = ""
        self.count = 0
        
        guard let id = UserDefaults.standard.string(forKey: "userid") else {return}
        
        let params = [
            "uid": id
        ]
        
        RestService.serviceCall(url: addrList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddressListModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                self.addrListModel = responseJson
                
                print(responseJson.data!.count)
                
                DispatchQueue.main.async {
                    self.count = responseJson.data?.count ?? 0
                    self.addressTableView.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Delivery availability
    func deliveryAvailability(value:Int, addrLat:String, addrLng:String) {
        
        let params = [
            "lat1": "\(latValue ?? 0.00)",
            "lng1": "\(longValue ?? 0.00)",
            "lat2": addrLat,
            "lng2": addrLng
        ]
        
        print(params)
        
        RestService.serviceCall(url: deleveryDistanceAvailability_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(DeliveryAvailabilityAddr.self, from: response) else{return}
            self.deliveryAvailabilityAddr = responseJson
            
            if responseJson.status == true {
                
                if self.isFrom == "deliverySummary"{
                    
                    let vc = self.storyboard?.instantiateViewController(identifier: "DeliverySummaryVC") as! DeliverySummaryVC
                    //                    //send address here after selecting sending fullAddr string
                    //                    var first = String()
                    //                    if let addr = self.addrListModel?.data[value] {
                    //                        first = addr.flotNo+" "+addr.landMark+" "+addr.street+" "+addr.address+" "+addr.pincode
                    //                    }
                    //
                    //                    vc.deliveryAddress = first
                    //                    vc.addrID = self.addrListModel!.data[value].id
                    vc.comingFrom = "Address"
                    
                    self.present(vc, animated: false, completion: nil)
                    
                }else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "SMTabbarController") as! SMTabbarController   
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: false, completion: nil)
                }
            }else{
                print(self.deliveryAvailabilityAddr!.message, "not available")
                self.isHiding = "Yes"
                
                showAlertMessage(vc: self, titleStr: "", messageStr: self.deliveryAvailabilityAddr!.message)
                cartStaticValue = "deliveryLocations"
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.addressTableView.reloadData()
                }) 
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension AddressListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return count
        }else{
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 {
            let cell : AddressListTVCell2 = self.addressTableView.dequeueReusableCell(withIdentifier: AddressListTVCell2.identifier, for: indexPath) as! AddressListTVCell2
            
            cell.addNewAddrBtn.addTarget(self, action: #selector(ontapNewAddressBtn), for: .touchUpInside)
            cell.storeLocationBtn.addTarget(self, action: #selector(onTapStoreLocationBtn), for: .touchUpInside)
            cell.storeLocationBtn.isHidden = true
            
            if isHiding == "Yes" {
                cell.storeLocationBtn.isHidden = false
            }else{
                cell.storeLocationBtn.isHidden = true
            }
            
            return cell
            
        }else if indexPath.section == 0 {
            let cell : AddressListTableViewCell = self.addressTableView.dequeueReusableCell(withIdentifier: "AddressListTableViewCell") as! AddressListTableViewCell
            
            if let addr = addrListModel!.data?[indexPath.row] {
                
                let first = (addr.flotNo ?? "")+" "+(addr.landMark ?? "")
                let second = (addr.street ?? "")+" "+(addr.address ?? "")
                fullAddr = first+" "+second+" "+(addr.pincode ?? "")
            }
            
            cell.addressLbl.text = fullAddr
            
            cell.editBtn.addTarget(self, action: #selector(editAction(sender:)), for: .touchUpInside)
            cell.editBtn.tag = indexPath.row
            cell.deleteBtn.addTarget(self, action: #selector(deleteAction(sender:)), for: .touchUpInside)
            cell.deleteBtn.tag = indexPath.row
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    //New Address Btn
    @objc func ontapNewAddressBtn() {
        
        let vc = storyboard?.instantiateViewController(identifier: "NewAddressAddViewController") as! NewAddressAddViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    //Nearest Stores
    @objc func onTapStoreLocationBtn() {
        
        let vc = storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            let details = addrListModel!.data?[indexPath.row]
            let adr1 = (details?.flotNo ?? "")+" "+(details?.landMark ?? "")
            let adr2 = (details?.street ?? "")
            let adr3 = (details?.address ?? "")+" "+(details?.pincode ?? "")
            let fullAdr = adr1+" "+adr2+" "+adr3
            
            AddrDetailsData.shared.addrID = details?.id ?? ""
            AddrDetailsData.shared.userAddress = fullAdr
            AddrDetailsData.shared.userlat = details?.ltd ?? ""
            AddrDetailsData.shared.userlong = details?.lng ?? ""
            
            //checking for availability of delivery
            if Reachability.isConnectedToNetwork() {
                deliveryAvailability(value: indexPath.row, addrLat: addrListModel!.data?[indexPath.row].ltd ?? "0.00", addrLng: addrListModel!.data?[indexPath.row].lng ?? "0.00")
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
            
        }
        
    }
}

//MARK:- extension
//Getting location lat and long
extension AddressListViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latValue = locValue.latitude
        longValue = locValue.longitude
        
    }
    
}
