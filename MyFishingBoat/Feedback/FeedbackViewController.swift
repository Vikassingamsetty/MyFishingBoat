//
//  FeedbackViewController.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 03/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController {

    @IBOutlet weak var SevicesTextlbl: UILabel!
    @IBOutlet weak var floatRatingView: FloatRatingView!
    
    var value:String = "\(0.0)"
    var status = ""
    var orderID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        update()
    }

func update() {
        
        // Reset float rating view's background color
        floatRatingView.backgroundColor = UIColor.white
        floatRatingView.delegate = self
        floatRatingView.contentMode = UIView.ContentMode.scaleAspectFit
        floatRatingView.type = .wholeRatings
        floatRatingView.rating = 0

        value = String(format: "%.1f", self.floatRatingView.rating)
        
    }
    
    @IBAction func submitBtn(_ sender: Any) {
        
        if status == "More" {
            if Reachability.isConnectedToNetwork() {
                feedBackServiceCall(order_ID: orderID) //API
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }else{
            showAlertMessage(vc: self, titleStr: "", messageStr: "Rate Us!!")
        }
        
    }
    
    //MARK:-API (Rating)
  
    //if rating is not given call this API
    func feedBackServiceCall(order_ID:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else {return}
        
        let params = [
        "uid": uid,
        "order_id": order_ID,
        "rate": value
        ]
        
        RestService.serviceCall(url: feedback_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(FeedbackModel.self, from: response) else{return}
            
            let delType = UserDefaults.standard.string(forKey: "deliveryType")!
            
            if responseJson.status == 200 {
                if delType == "delivery" {
                    let vc = self.storyboard?.instantiateViewController(identifier: "AddressListViewController") as! AddressListViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }else{
                    let vc = self.storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true, completion: nil)
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension FeedbackViewController: FloatRatingViewDelegate {

    // MARK: FloatRatingViewDelegate
    
//    func floatRatingView(_ ratingView: FloatRatingView, isUpdating rating: Double) {
//        liveLabel.text = String(format: "%.2f", self.floatRatingView.rating)
//    }
    
    func floatRatingView(_ ratingView: FloatRatingView, didUpdate rating: Double) {
        
        value = String(format: "%.1f", self.floatRatingView.rating)
        print(value, "values feedback")
        if value > "\(1.0)" {
            status = "More"
        }
        
    }
    
}
