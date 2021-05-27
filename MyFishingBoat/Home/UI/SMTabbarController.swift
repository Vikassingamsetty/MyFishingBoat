//
//  SMTabbarController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

class SMTabbarController: UITabBarController {
    
    var locationManager: CLLocationManager!
    var currentLocation: CLLocation?
    var mapView: GMSMapView!
    var placesClient: GMSPlacesClient!
    var zoomLevel: Float = 15.0
    
    let lat = 14.442599
    let long = 79.986458
    
    var locManager = CLLocationManager()
    var lattitude : Double!
    var longitude : Double!
    var pickError: PickupError!
    var pickSuccess: PickupLocationPincode!
    //var vc = FeedbackViewController()
    
    var city = String()
    
    //New models
    var availableStoreModel:AvailableStoreModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        
        //getting uuid of device
        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
            print(uuid, "uuid")
        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        mapsData()
        
        // geoCoding()
        
        //        if UserDefaults.standard.string(forKey: "userid") == nil {
        //            self.tabBarController?.tabBar.items?[2].badgeValue = "0"
        //        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Home" {
            let nextView = segue.destination as! HomeViewController
            nextView.sampleTest(city: city)
        }
        
        if segue.identifier == "Cart" || segue.identifier == "Wishlist" || segue.identifier == "Profile" || segue.identifier == "Search" {
            print("Set values true")
            UserDefaults.standard.setValue("Yes", forKey: "FromTab")
        }
        
    }
    
    func geoCoding() {
        
        self.tabBarController?.tabBar.isHidden = false // tabBarController exists
        
        locManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            
            switch CLLocationManager.authorizationStatus() {
            
            case .notDetermined, .restricted, .denied:
                print("No access")
                
                
                let alert = UIAlertController(title: "Alert", message: "Please enable your location", preferredStyle: UIAlertController.Style.alert)
                
                // add the actions (buttons)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { action in
                    //self.geoCoding()
                    
                    if let BUNDLE_IDENTIFIER = Bundle.main.bundleIdentifier,
                        let url = URL(string: "\(UIApplication.openSettingsURLString)&path=LOCATION/\(BUNDLE_IDENTIFIER)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                    
                    //UIApplication.shared.open(URL(string:UIApplication.openSettingsURLString)!)
                }))
                
                // show the alert
                self.present(alert, animated: true, completion: nil)
                
            case .authorizedAlways, .authorizedWhenInUse:
                if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedWhenInUse ||
                        CLLocationManager.authorizationStatus() == CLAuthorizationStatus.authorizedAlways){
                    guard let currentLocation = locManager.location else {
                        return
                    }
                    lattitude = currentLocation.coordinate.latitude
                    longitude = currentLocation.coordinate.longitude
                    
                    //saving user lat and long
                    UserDefaults.standard.setValue("\(currentLocation.coordinate.latitude)", forKey: "lat")
                    UserDefaults.standard.setValue("\(currentLocation.coordinate.longitude)", forKey: "lng")
                    
                    if lattitude != 0.0 {
                        let location1 = CLLocation(latitude: lattitude, longitude: longitude)
                        
                        CLGeocoder().reverseGeocodeLocation(location1) { placemarks, error in
                            
                            guard let placemark = placemarks?.first else {
                                let errorString = error?.localizedDescription ?? "Unexpected Error"
                                print("Unable to reverse geocode the given location. Error: \(errorString)")
                                return
                            }
                            
                            let reversedGeoLocation = ReversedGeoLocation(with: placemark)
                            print(reversedGeoLocation.streetName)
                            print(reversedGeoLocation.zipCode)
                            print(reversedGeoLocation.city)
                            print(reversedGeoLocation.country)
                            print(reversedGeoLocation.name)
                            let pincode = reversedGeoLocation.zipCode
                            UserDefaults.standard.set(pincode, forKey: "pincode")
                            print("pincode",pincode)
                            self.city = "\(reversedGeoLocation.name+" "+reversedGeoLocation.city)"
                            UserDefaults.standard.set(self.city, forKey: "city")
                            print(self.city)
                            let vc = self.viewControllers![0] as! HomeViewController
                            vc.sampleTest(city: self.city)
                            self.theFunction()
                        }
                    }
                }
            default:
                print("error in location home screen")
            }
        } else {
            print("Location services are not enabled")
        }
        
    }
    
    
    func mapsData() {
        
        // Initialize the location manager.
        locationManager = CLLocationManager()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 50
        locationManager.startUpdatingLocation()
        locationManager.delegate = self
        
        placesClient = GMSPlacesClient.shared()
        
        // Create a map.
        let camera = GMSCameraPosition.camera(withLatitude:0.0,
                                              longitude: 0.0,
                                              zoom: zoomLevel)
        mapView = GMSMapView.map(withFrame: view.bounds, camera: camera)
        mapView.settings.myLocationButton = true
        mapView.settings.compassButton = true
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mapView.isMyLocationEnabled = true
        
        // Add the map to the view, hide it until we've got a location update.
        //view.addSubview(mapView)
        mapView.isHidden = true
        
    }
    
    func theFunction(){
        
        struct Holder { static var called = false }
        print("123344444444")
        if !Holder.called {
            Holder.called = true
            
            if Reachability.isConnectedToNetwork() {
                let vc = self.storyboard?.instantiateViewController(identifier: "StoreAvailabilityVC") as! StoreAvailabilityVC
                vc.modalPresentationStyle = .overCurrentContext
                vc.modalTransitionStyle = .crossDissolve
                //vc.serviceType = "service"
                //vc.storeId = self.availableStoreModel!.data[0].id
                self.present(vc, animated: false, completion: nil)
                
                //storeAvailabilityAPI()
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
            
        }
    }
    
    //Servicable or nonserviceable location
    func storeAvailabilityAPI() {
        
        let params = [
            "lat": "\(lattitude!)",
            "lng": "\(longitude!)"
        ]
        
        print(params)
        
        RestService.serviceCall(url: storeAvail_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            do{
                let responseJson = try JSONDecoder().decode(AvailableStoreModel.self, from: response)
                self.availableStoreModel = responseJson
                if responseJson.status == true {
                    print("success")
                    let vc = self.storyboard?.instantiateViewController(identifier: "StoreAvailabilityVC") as! StoreAvailabilityVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    //vc.serviceType = "service"
                    vc.storeId = self.availableStoreModel!.data[0].id ?? ""
                    self.present(vc, animated: false, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(identifier: "StoreAvailabilityVC") as! StoreAvailabilityVC
                    vc.modalPresentationStyle = .overCurrentContext
                    vc.modalTransitionStyle = .crossDissolve
                    //vc.serviceType = "nonservice"
                    self.present(vc, animated: false, completion: nil)
                    print("location error")
                    print(self.availableStoreModel!.message)
                }
            }catch{
                print("location error 1")
                showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension SMTabbarController: CLLocationManagerDelegate {
    
    // Handle incoming location events.
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location: CLLocation = locations.last!
        print("Location: \(location)")
        
        let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                              longitude: location.coordinate.longitude,
                                              zoom: zoomLevel)
        
        print(location.coordinate.latitude, location.coordinate.longitude)
        
        if mapView.isHidden {
            mapView.isHidden = false
            mapView.camera = camera
        } else {
            mapView.animate(to: camera)
        }
        
    }
    
    // Handle authorization for the location manager.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        switch status {
        case .restricted:
            print("Location access was restricted.")
            
        case .denied:
            print("User denied access to location.")
            // Display the map using the default location.
            mapView.isHidden = false
            
        case .notDetermined:
            print("Location status not determined.")
        case .authorizedAlways: fallthrough
            
        case .authorizedWhenInUse:
            print("Location status is OK.")
            DispatchQueue.main.async {
                self.geoCoding()
            }
        default:
            fatalError()
        }
    }
    
    // Handle location manager errors.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print("Error: \(error)")
    }
}


