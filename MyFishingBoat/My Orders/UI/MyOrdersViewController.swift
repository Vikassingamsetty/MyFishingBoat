//
//  ViewController.swift
//  CustomSEgmentedControl
//
//  Created by Leela Prasad on 18/01/18.
//  Copyright © 2018 Leela Prasad. All rights reserved.
//

import UIKit

class MyOrdersViewController: BaseViewController{

    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var displayView: UIView!
    
    let liveOrders = LiveOrdersViewController()
    let pastOrders = PastordersViewController()
    
    private let scroll:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    //Model
    var liveOrdersModel:LiveOrdersModel?
    var pastOrdersModel:PastOrdersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Menu btn
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        segmentController.backgroundColor = .white
        fontstyle(segment: segmentController, state: .normal, fontName: "MyriadPro-Regular", fontSize: 12, foregroundColor: UIColor.colorFromHex("#717376"))
        fontstyle(segment: segmentController, state: .selected, fontName: "MyriadPro-Semibold", fontSize: 12, foregroundColor: UIColor.colorFromHex("#545557"))
        
        segmentController.addUnderlineForSelectedSegment()
        
        ViewEmbedder.embed(withIdentifier: "LiveOrdersViewController",parent: self,container: self.displayView){ vc in
            // do things when embed complete
            vc.isEditing = true
        }
        
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//
//        //addchild
//        addChild(liveOrders)
//        addChild(pastOrders)
//
//        displayView.addSubview(scroll)
//        scroll.frame = displayView.bounds
//
//        scroll.addSubview(liveOrders.view)
//        scroll.addSubview(pastOrders.view)
//
//        //setting up frame
//        liveOrders.view.frame = CGRect(x: 0,
//                                          y: 0,
//                                          width: scroll.frame.size.width,
//                                          height: scroll.frame.size.height)
//
//        pastOrders.view.frame = CGRect(x: scroll.frame.size.width,
//                                           y: 0,
//                                           width: scroll.frame.size.width,
//                                           height: scroll.frame.size.height)
//        //moving vc to parentclass
//        liveOrders.didMove(toParent: self)
//        pastOrders.didMove(toParent: self)
//
//    }
    
    
    @IBAction func segmentControllerAction(_ sender: Any) {
        
        segmentController.changeUnderlinePosition()
        
        if segmentController.selectedSegmentIndex == 0 {
            print("live order")
            //scroll.setContentOffset(.zero, animated: true)
            
            ViewEmbedder.embed(withIdentifier: "LiveOrdersViewController",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            
        }else{
            
            ViewEmbedder.embed(withIdentifier: "PastordersViewController",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            
            //scroll.setContentOffset(CGPoint(x: displayView.frame.size.width, y: 0), animated: true)
            print("past order")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        segmentController.changeUnderlinePosition()
        
        if segmentController.selectedSegmentIndex == 0 {
            print("live order")
            
            ViewEmbedder.embed(withIdentifier: "LiveOrdersViewController",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            
//            scroll.setContentOffset(.zero, animated: true)
//            serverCall()
        }else{
            
            ViewEmbedder.embed(withIdentifier: "PastordersViewController",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
//            scroll.setContentOffset(CGPoint(x: displayView.frame.size.width, y: 0), animated: true)
//            serverCall1()
            print("past order")
        }
        
    }
    
    func serverCall() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
        "uid": uid,
        "ordertype": "Active"
        ]
        
        RestService.serviceCall(url: myorders_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(LiveOrdersModel.self, from: response) else{return}
            self.liveOrdersModel = responseJson
            if responseJson.status == 200 {
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "No Live Orders")
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    func serverCall1() {
        print("past")
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
        "uid": uid,
        "ordertype": "Past"
        ]
        
        RestService.serviceCall(url: myorders_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(PastOrdersModel.self, from: response) else{return}
            self.pastOrdersModel = responseJson
            if responseJson.status == 200 {
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "No Past Orders")
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}
