//
//  NewAddressAddViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import iOSDropDown
import GoogleMaps
import CoreLocation

class NewAddressAddViewController: UIViewController, UITextFieldDelegate, GMSMapViewDelegate {
    
    @IBOutlet weak var areaNameTF: UITextField!
    @IBOutlet weak var flatNoTF: UITextField!
    @IBOutlet weak var streetTF: UITextField!
    @IBOutlet weak var landmarkTF: UITextField!
    @IBOutlet weak var pincodeTF: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    
    @IBOutlet weak var locationImageCenter: UIImageView!
    @IBOutlet weak var addressTypeTF: DropDown!
    
    //Google maps
    private var locationManager:CLLocationManager?
    private var marker = GMSMarker()
    //lat and long storage
    var latValue = Double()
    var longValue = Double()
    
    //getting data on edit btn tapped
    var areaName = String()
    var flatNo = String()
    var streetName = String()
    var landmark = String()
    var pincode = String()
    var addrType = String()
    //tapped type and edit button indexpath
    var tappedOn = String()
    var editTag = String()
    
    //dropdown
    var optionArray1 = ["Home","Office (Commercial)"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        areaNameTF.isUserInteractionEnabled = false
        streetTF.isUserInteractionEnabled = false
        pincodeTF.isUserInteractionEnabled = false
        
        addressTypeTF.layer.cornerRadius = 20
        addressTypeTF.layer.borderWidth = 1
        addressTypeTF.layer.borderColor = #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1)
        
        addressTypeTF.optionArray = self.optionArray1
        addressTypeTF.selectedRowColor = #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 0.5)
        
        addressTypeTF.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 5))
        addressTypeTF.leftViewMode = .always
        
        if tappedOn == "edit" {
            print(latValue, longValue, "edit button")
            mapView.isMyLocationEnabled = true
            getUserLocation()
            addMarker(lat: latValue , long: longValue)
            self.areaNameTF.text = self.areaName
            self.flatNoTF.text = self.flatNo
            self.streetTF.text = self.streetName
            self.landmarkTF.text = self.landmark
            self.pincodeTF.text = self.pincode
            self.addressTypeTF.text = self.addrType
        }else{
            getUserLocation()
        }
        
    }
    
    //MARK:- getting location
    func getUserLocation() {
        locationManager = CLLocationManager()
        locationManager?.requestAlwaysAuthorization()
        locationManager?.requestWhenInUseAuthorization()
        //locationManager?.allowsBackgroundLocationUpdates = false
        mapView.isMyLocationEnabled = true
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager?.delegate = self
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            
            if tappedOn == "edit" {
                //locationManager?.startUpdatingLocation()
            }else{
                locationManager?.startUpdatingLocation()
            }
            
        }
        
    }
    func reverseGeocoding(marker: GMSMarker){
        getAddressFromLatLon(latitudeValue: marker.position.latitude, withLongitude: marker.position.longitude)
    }
    //MARK:- Get address from lat long values
    func getAddressFromLatLon(latitudeValue: Double, withLongitude longituteValue: Double) {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        let lat: Double = latitudeValue
        //21.228124
        let lon: Double = longituteValue
        //72.833770
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = lat
        center.longitude = lon
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        let locCamera = GMSCameraPosition.camera(withLatitude: lat,
                                                 longitude: lon,
                                                 zoom: 15)
        mapView.camera = locCamera
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
                                    {[weak self] (placemarks, error) in
                                        
                                        guard let self = self else{return}
                                        
                                        if (error != nil)
                                        {
                                            print("reverse geodcode fail: \(error!.localizedDescription)")
                                        }
                                        let pm = placemarks! as [CLPlacemark]
                                        
                                        if pm.count > 0 {
                                            let pm = placemarks![0]
                                            print(pm.country as Any)
                                            print(pm.locality as Any)
                                            print(pm.subLocality as Any)
                                            print(pm.thoroughfare as Any)
                                            print(pm.postalCode as Any)
                                            print(pm.subThoroughfare as Any)
                                            
                                            //                    if self.tappedOn == "edit" {
                                            //
                                            //                        self.areaNameTF.text = self.areaName
                                            //                        self.flatNoTF.text = self.flatNo
                                            //                        self.streetTF.text = self.streetName
                                            //                        self.landmarkTF.text = self.landmark
                                            //                        self.pincodeTF.text = self.pincode
                                            //                        self.addressTypeTF.text = self.addrType
                                            //                    }else{
                                            //fill the textfields with the data
                                            self.areaNameTF.text = (pm.locality ?? "")
                                            self.flatNoTF.text = ""
                                            let areas = (pm.subThoroughfare ?? "") + " " + (pm.thoroughfare ?? "")
                                            self.streetTF.text = areas+" "+(pm.subLocality ?? "")
                                            self.landmarkTF.text = ""
                                            self.pincodeTF.text = pm.postalCode ?? ""
                                            //}
                                            
                                            
                                        }
                                    })
        
    }
    
    @IBAction func locateOnMapBtnAction(_ sender: Any) {
        //show current location of user
        //mapView.isMyLocationEnabled = true
        //mapView.clear()
        //getUserLocation()
        addMarker(lat: latValue, long: longValue)
        getAddressFromLatLon(latitudeValue: latValue, withLongitude: longValue)
        print(latValue, longValue, "lat long values")
    }
    
    @IBAction func newAddresBtnAction(_ sender: Any) {
        
        if addressTypeTF.text!.isEmpty {
            showAlertMessage(vc: self, titleStr: "", messageStr: "Provide address type")
        }else{
            if areaNameTF.text!.isEmpty {
                showAlertMessage(vc: self, titleStr: "", messageStr: "Provide area name")
            }else{
                if flatNoTF.text!.isEmpty {
                    showAlertMessage(vc: self, titleStr: "", messageStr: "Provide flat no")
                }else{
                    if streetTF.text!.isEmpty {
                        showAlertMessage(vc: self, titleStr: "", messageStr: "Provide street name")
                    }else{
                        if landmarkTF.text!.isEmpty {
                            showAlertMessage(vc: self, titleStr: "", messageStr: "Provide a landmark")
                        }else{
                            if pincodeTF.text!.isEmpty {
                                showAlertMessage(vc: self, titleStr: "", messageStr: "Provide pincode")
                            }else{
                                
                                if pincodeTF.text!.count != 6 {
                                    showAlertMessage(vc: self, titleStr: "", messageStr: "Only 6 digit pincode")
                                }else{
                                    if Reachability.isConnectedToNetwork() {
                                        
                                        if self.tappedOn == "edit" {
                                            userEditAddr()
                                        }else{
                                            //new addr
                                            addUserAddr()
                                        }
                                        
                                    }else {
                                        showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    //MARK:- API calls
    //add new address
    func addUserAddr() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "uid":uid,
            "address_type":addressTypeTF.text ?? "",
            "address":areaNameTF.text ?? "",
            "street":streetTF.text ?? "",
            "flot_no":flatNoTF.text ?? "",
            "land_mark":landmarkTF.text ?? "",
            "pincode":pincodeTF.text ?? "",
            "ltd":"\(latValue)",
            "lng":"\(longValue)"
        ]
        
        RestService.serviceCall(url: newaddr_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(NewAddrModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.dismiss(animated: false)
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
    //edit user address
    func userEditAddr() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        let params = [
            "id": editTag,
            "uid": uid,
            "address_type": addressTypeTF.text ?? "",
            "address":areaNameTF.text ?? "",
            "street":streetTF.text ?? "",
            "flot_no":flatNoTF.text ?? "",
            "land_mark":landmarkTF.text ?? "",
            "pincode":pincodeTF.text!,
            "ltd":"\(latValue)",
            "lng":"\(longValue)"
        ]
        
        RestService.serviceCall(url: editaddr_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(NewAddrModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1) {
                    self.dismiss(animated: false, completion: nil)
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

//MARK:- extension
//Getting location lat and long
extension NewAddressAddViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
        print("locations = \(locValue.latitude) \(locValue.longitude)")
        latValue = locValue.latitude
        longValue = locValue.longitude
        
        let locCamera = GMSCameraPosition.camera(withLatitude: locValue.latitude,
                                                 longitude: locValue.longitude,
                                                 zoom: 15)
        mapView.camera = locCamera
        addMarker(lat: latValue, long: longValue)
        getAddressFromLatLon(latitudeValue: latValue, withLongitude: longValue)
        
//        addMarker(lat: latValue!, long: longValue!)
    }
    //MARK:-ADDING MARKER
    func addMarker(lat:Double, long:Double) {
        //Adding a marker to the view
        marker.position = CLLocationCoordinate2D(latitude: lat, longitude: long)
        marker.map = mapView
        let locCamera = GMSCameraPosition.camera(withLatitude: lat,
                                                 longitude: long,
                                                 zoom: 15)
        mapView.camera = locCamera
//        marker.isDraggable = true
        marker.map = mapView
        marker.map = nil

    }
    
    func mapView(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
           //        print("Idle At Camera Position")
           let latitude = String(format: "%.6f", mapView.camera.target.latitude )
           let longitude = String(format: "%.6f", mapView.camera.target.longitude )
        latValue = Double(latitude) ?? 0.000
        longValue = Double(longitude) ?? 0.000
        print(latitude, longitude, "static values vikas")
        locationManager?.stopUpdatingLocation()
        addMarker(lat: latValue, long: longValue)
        getAddressFromLatLon(latitudeValue: latValue, withLongitude: longValue)
       }
    
}
//marker moving
extension NewAddressAddViewController{
    func mapView(_ mapView: GMSMapView, didEndDragging marker: GMSMarker) {
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
        reverseGeocoding(marker: marker)
        latValue = marker.position.latitude
        longValue = marker.position.longitude
        locationManager?.stopUpdatingLocation()
        print("Position of marker is = \(marker.position.latitude),\(marker.position.longitude)")
    }
    func mapView(_ mapView: GMSMapView, didBeginDragging marker: GMSMarker) {
        print("didBeginDragging")
    }
    func mapView(_ mapView: GMSMapView, didDrag marker: GMSMarker) {
        print("didDrag")
    }
}

