//
//  StoreLocaterViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 23/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import CoreLocation
import SafariServices

class StoreLocaterViewController : BaseViewController, UITextFieldDelegate,CLLocationManagerDelegate {
    
    @IBOutlet weak var UserCityLocationOutlet: UIButton!
    @IBOutlet weak var storeLocaterListTableView: UITableView!
    @IBOutlet weak var homeBtnOutlet: UIButton!
    
    //MODELS
    var storeDetailsModel:StoreDetailsModel?
    
    //coming from pickupSummary
    var comingFrom = String()
    
    var storeLocation = ""
    
    var locationManager = CLLocationManager()
    var userLat : Double?
    var userLong : Double?
    var lattitude3 : Double!
    var longitude3 : Double!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        storeLocaterListTableView.estimatedRowHeight = storeLocaterListTableView.rowHeight
        storeLocaterListTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    func locationUser() {
        //        if UserDefaults.standard.string(forKey: "city") != nil {
        //            let city = UserDefaults.standard.value(forKey: "city") as! String
        //            self.UserCityLocationOutlet.setTitle(city, for: .normal)
        //        }else {
        //            showAlertMessage(vc: self, titleStr: "Location", messageStr: "NO location access given")
        //        }
        
        
        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        locationManager.requestWhenInUseAuthorization()
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
            guard let currentLocation = locationManager.location else {
                return
            }
            self.userLat = currentLocation.coordinate.latitude
            self.userLong = currentLocation.coordinate.longitude
            
            print("lat",userLat ?? "")
            print("long",userLong ?? "")
            
        }
    }
    
    func openGoogleMap(dlat:String, dlong:String) {
        
        //pinakini evenue
        let slat = userLat
        let slong = userLong
        
        if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!)) {  //if phone has an app
            
            if let url = URL(string:"comgooglemaps://?saddr=\(slat ?? 0.00),\(slong ?? 0.00)&daddr=\(dlat),\(dlong)&directionsmode=driving&zoom=14&views=traffic") {
                UIApplication.shared.open(url, options: [:])
            }}
        else {
            //Open in browser
            if let urlDestination = URL.init(string: "https://www.google.co.in/maps/dir/?saddr=\(slat ?? 0.00),\(slong ?? 0.00)&daddr=\(dlat),\(dlong)&directionsmode=driving") {
                UIApplication.shared.open(urlDestination)
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Reachability.isConnectedToNetwork() {
            locationUser()
            storeDetailsApi()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //APICall
    func storeDetailsApi() {
        
        let params = [
            "lat": "\(userLat ?? 0.00)",
            "lng": "\(userLong ?? 0.00)"
        ]
        
        print(params)
        
        RestService.serviceCall(url: storeLocations_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(StoreDetailsModel.self, from: response) else{return}
            self.storeDetailsModel = responseJson
            if responseJson.status == 200 {
                DispatchQueue.main.async {
                    self.storeLocaterListTableView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.storeDetailsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
    
    @objc func makeCall(sender: UIButton){
        print("making call")
        
        let phoneNo = Int(storeDetailsModel!.data?[sender.tag].phone ?? "0")
        
        let url:URL = URL(string: "TEL://\(phoneNo!)")!
        print(phoneNo!)
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    
    @objc func storeLocation(sender: UIButton){
        
        self.openGoogleMap(dlat: storeDetailsModel!.data?[sender.tag].lat ?? "0.00", dlong: storeDetailsModel!.data?[sender.tag].lng ?? "0.00")
    }
    
    
    func getLocation(from address: String, completion: @escaping (_ location: CLLocationCoordinate2D?)-> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks,
                  let location = placemarks.first?.location?.coordinate else {
                completion(nil)
                return
            }
            completion(location)
        }
    }
    
}



extension StoreLocaterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = storeDetailsModel?.data?.count {
            print(count, "store")
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell : StoreLocaterTableViewCell = self.storeLocaterListTableView.dequeueReusableCell(withIdentifier: "StoreLocaterTableViewCell") as! StoreLocaterTableViewCell
        
        
        let details = storeDetailsModel!.data?[indexPath.row]
        let distance = details?.distance ?? ""
        cell.distancetxt.text = "\(distance.toDouble()!.rounded(toPlaces: 2)) km"
        cell.nameLbl.setTitle(details?.storeName ?? "", for: .normal)
        
        let addr1 = details?.landmark ?? ""
        let addr2 = details?.address ?? ""
        let addr3 = details?.pincode ?? ""
        let fullAddr = addr1+" "+addr2+" "+addr3
        
        cell.addressLbl.text = fullAddr
        
        cell.callBtnOutlet.tag = indexPath.row
        cell.callBtnOutlet.addTarget(self, action: #selector(makeCall(sender:)), for: .touchUpInside)
        cell.directionsBtnOutlet.addTarget(self, action: #selector(storeLocation(sender:)), for: .touchUpInside)
        cell.directionsBtnOutlet.tag = indexPath.row
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = storeLocaterListTableView.cellForRow(at: indexPath) as! StoreLocaterTableViewCell
        
        let details = storeDetailsModel?.data?[indexPath.row]
        let addr1 = details?.landmark ?? ""
        let addr2 = details?.address ?? ""
        let addr3 = details?.pincode ?? ""
        
        let fullAddr = addr1+" "+addr2+" "+addr3
        
        StoreDetailsData.shared.storeID = details?.id ?? ""
        StoreDetailsData.shared.storeName = details?.storeName ?? ""
        StoreDetailsData.shared.storeAddress = fullAddr
        StoreDetailsData.shared.km = cell.distancetxt.text!
        StoreDetailsData.shared.phoneNumber = details?.phone ?? ""
        StoreDetailsData.shared.userlat = "\(userLat ?? 0.00)"
        StoreDetailsData.shared.userlong = "\(userLong ?? 0.00)"
        StoreDetailsData.shared.storelat = details?.lat ?? ""
        StoreDetailsData.shared.storelong = details?.lng ?? ""
        
        UserDefaults.standard.set("pickup", forKey: "deliveryType")
        
        if cartStaticValue == "" {
            
        }else if cartStaticValue == "deliveryLocations"{
            cartScreenValue = "pickup"
            //if cartScreenValue == "pickup" {
                let vc = storyboard?.instantiateViewController(identifier: "CartViewController") as! CartViewController
                vc.modalPresentationStyle = .fullScreen
                present(vc, animated: false, completion: nil)
            //}
        }
        
        if comingFrom == "pickup" {
            cartScreenValue = "pickup"
            let vc = storyboard?.instantiateViewController(identifier: "PickupSummaryVC") as! PickupSummaryVC
            vc.modalPresentationStyle = .fullScreen
            vc.comingFrom = "Store"
            present(vc, animated: false, completion: nil)
            
        } else {
            cartStaticValue = ""
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
        
    }
    
}


