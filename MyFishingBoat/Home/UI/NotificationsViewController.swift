//
//  NotificationsViewController.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class NotificationsViewController: BaseViewController {
    
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var displayView: UIView!
    
    let orderStatusVC = NotificationOrderStatusVC()
    let orderDetailsVC = NotificationOrderDetailsVC()
    
    var orderNum = String()
    
    let scrollView:UIScrollView = {
        let scroll = UIScrollView()
        scroll.isPagingEnabled = true
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: .touchUpInside)
        
        segmentController.addUnderlineForSelectedSegment()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segmentController.changeUnderlinePosition()
        
        if segmentController.selectedSegmentIndex == 0 {
            print("slected orderstatus vc")
            scrollView.setContentOffset(.zero, animated: true)
            
            ViewEmbedder.embed(withIdentifier: "NotificationOrderStatusVC",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            
        }else{
            scrollView.setContentOffset(CGPoint(x: displayView.frame.size.width, y: 0), animated: true)
            
            ViewEmbedder.embed(withIdentifier: "NotificationOrderDetailsVC",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            
            print("orderDetailsVC")
        }
        
        fontstyle(segment: segmentController, state: [.normal], fontName: "MyriadPro-Regular", fontSize: 14, foregroundColor: UIColor.colorFromHex("#717376"))
        
        fontstyle(segment: segmentController, state: [.selected], fontName: "MyriadPro-Semibold", fontSize: 14, foregroundColor: UIColor.colorFromHex("#545557"))
        
    }
    
    
    @IBAction func segmentControllerAction(_ sender: Any) {
        
        segmentController.changeUnderlinePosition()
        
        if segmentController.selectedSegmentIndex == 0 {
            print("slected orderstatus vc")
            scrollView.setContentOffset(.zero, animated: true)
            
            ViewEmbedder.embed(withIdentifier: "NotificationOrderStatusVC",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
        }else{
            scrollView.setContentOffset(CGPoint(x: displayView.frame.size.width, y: 0), animated: true)
            
            ViewEmbedder.embed(withIdentifier: "NotificationOrderDetailsVC",parent: self,container: self.displayView){ vc in
                // do things when embed complete
                vc.isEditing = true
            }
            print("orderDetailsVC")
        }
    }
    
}
