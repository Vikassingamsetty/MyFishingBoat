//
//  MapTVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import GooglePlaces
import GoogleMaps
import Alamofire
import SwiftyJSON

class MapTVCell: UITableViewCell,CLLocationManagerDelegate {
    
    @IBOutlet weak var GoogleMapsView: GMSMapView!
    var lattitude2 : Double!
    var longitude2 : Double!
    var lattitude3 : Double!
    var longitude3 : Double!
    var zoom: Float = 10
    var locationManager = CLLocationManager()
    static let identifier = "MapTVCell"
    static func nib() -> UINib {
        return UINib(nibName: "MapTVCell", bundle: nil)
    }
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var displayMapView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            self.lattitude2 = currentLocation.coordinate.latitude
            self.longitude2 = currentLocation.coordinate.longitude
            self.lattitude3 = currentLocation.coordinate.latitude+00.10000000000000
            self.longitude3 = currentLocation.coordinate.longitude+00.10000000000000
            print("locccc",lattitude3)
            print("oooo",lattitude3)
            
        }
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print("COORDINATE \(coordinate)") // when you tapped coordinate
    }
    
    func createMarker(titleMarker: String, iconMarker: UIImage, latitude: CLLocationDegrees, longitude: CLLocationDegrees) {
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(latitude, longitude)
        marker.title = titleMarker
        marker.icon = iconMarker
        marker.setIconSize(scaledToSize: CGSize(width: 60, height: 60))
        marker.map = GoogleMapsView
    }
    
    //MARK: - Location Manager delegates
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error to get location : \(error)")
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        
        let location = locations.last! as CLLocation
        
        /* you can use these values*/
        let lat = location.coordinate.latitude
        let long = location.coordinate.longitude
        print("lat123\(lat)")
        print("long123\(long)")
        
        
        let camera = GMSCameraPosition.camera(withLatitude: (location.coordinate.latitude), longitude: (location.coordinate.longitude), zoom: 8.0)
        self.GoogleMapsView.animate(to: camera)
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func latLngValues(values: PastOrderDetailsModel) {
        
        
        if values.data[0].deliveryType == "delivery" {
            let slat = Double(values.data[0].ltd ?? "0.00") ?? 0.00
            let slng = Double(values.data[0].ltd ?? "0.00") ?? 0.00
            let dlat = Double(values.data[0].dbLtd ?? "0.00") ?? 0.00
            let dlng = Double(values.data[0].dbLng ?? "0.00") ?? 0.00
            PloyLineDirections(sLat: slat, sLng: slng, eLat: dlat, eLng: dlng, type: "delivery")
        }else{
            let slat = self.lattitude2 ?? 0.00//Double(values.data[0].dbLtd ?? "0.00") ?? 0.00
            let slng = self.longitude2 ?? 0.00//Double(values.data[0].dbLng ?? "0.00") ?? 0.00
            let dlat = Double(values.data[0].storeLat ?? "0.00") ?? 0.00
            let dlng = Double(values.data[0].storeLng ?? "0.00") ?? 0.00
            PloyLineDirections(sLat: slat, sLng: slng, eLat: dlat, eLng: dlng, type: "pickup")
        }
        
        
        
    }
    
    func PloyLineDirections(sLat:Double,sLng:Double,eLat:Double,eLng:Double, type: String){
//            let myString = ""
//        let myFloat = (myString as NSString).floatValue
//            let myString2 = ""
//            let myFloat2 = (myString2 as NSString).floatValue
//            createMarker(titleMarker: "EndLocation", iconMarker: #imageLiteral(resourceName: "checkin-1"), latitude: Double(myFloat), longitude:Double(myFloat2))
//        createMarker(titleMarker: "EndLocation", iconMarker: #imageLiteral(resourceName: "checkin-1"), latitude: self.lattitude3, longitude:self.longitude3)
//            print("lo",self.lattitude3,self.longitude3)
//        createMarker(titleMarker: "StartLocation", iconMarker: #imageLiteral(resourceName: "checkin-1"), latitude: Double(self.lattitude2), longitude:Double(self.longitude2))
//
//        let origin = "\(self.lattitude2!),\(self.longitude2!)"
//        let destination = "\((self.lattitude3!)),\((self.longitude3!))"
        
        if type == "delivery" { //1.user, 2.boy
            createMarker(titleMarker: "EndLocation", iconMarker: #imageLiteral(resourceName: "Storepoint"), latitude: eLat, longitude:eLng)
                print("lo",self.lattitude3,self.longitude3)
            createMarker(titleMarker: "StartLocation", iconMarker: #imageLiteral(resourceName: "UserPoint"), latitude: sLat, longitude:sLng)
        }else{ //1.user, 2.store
            createMarker(titleMarker: "EndLocation", iconMarker: #imageLiteral(resourceName: "Storepoint"), latitude: eLat, longitude:eLng)
                print("lo",self.lattitude3,self.longitude3)
            createMarker(titleMarker: "StartLocation", iconMarker: #imageLiteral(resourceName: "UserPoint"), latitude: sLat, longitude:sLng)
        }
        
        
        let origin = "\(sLat),\(sLng)"
        let destination = "\(eLat),\(eLng)"

            let url = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=driving&key=AIzaSyBF-3N0u9TsMaEFyS7WuS-2qNB9gbhich0"
            
            print("url\(url)")
            
            AF.request(url).responseJSON { response in
                let json = try? JSON(data: response.data!)
                let routes = json!["routes"].arrayValue
                print(json)
                for route in routes
                {
                    let routeOverviewPolyline = route["overview_polyline"].dictionary
                    let points = routeOverviewPolyline?["points"]?.stringValue
                    let path = GMSPath.init(fromEncodedPath: points!)
                    
                    let polyline = GMSPolyline(path: path)
                    polyline.strokeColor = UIColor.black
                    polyline.strokeWidth = 6
                    polyline.map = self.GoogleMapsView
                    self.zoom = self.zoom + 1
                    self.GoogleMapsView.animate(toZoom: self.zoom)
                    //self.timer = Timer.scheduledTimer(timeInterval: 0.003, target: self, selector: #selector(self.animatePolylinePath), userInfo: nil, repeats: true)
                    
                }
            }
            
            
        }
    
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
