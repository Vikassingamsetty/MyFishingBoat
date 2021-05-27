//
//  ResturentOwnersViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//
import UIKit

class ResturentOwnersViewController: BaseViewController {
    
    @IBOutlet weak var homeBtnOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        self.dismiss(animated: false, completion: nil)
    }
    
}
