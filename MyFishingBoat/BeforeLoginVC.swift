//
//  BeforeLoginVC.swift
//  MyFishingBoat
//
//  Created by vikas on 10/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class BeforeLoginVC: UIViewController {

    @IBOutlet weak var loginBtn:UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func onTapLogin(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "SendOTPViewController") as! SendOTPViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
}
