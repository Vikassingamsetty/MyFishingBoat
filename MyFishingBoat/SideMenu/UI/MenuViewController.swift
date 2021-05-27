//
//  MenuViewController.swift
//  AKSwiftSlideMenu
//
//  Created by Ashish on 21/09/15.
//  Copyright (c) 2015 Kode. All rights reserved.
//

import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    /**
     *  Array to display menu options
     */
    @IBOutlet var tblMenuOptions : UITableView!
    
    /**
     *  Transparent button to hide menu
     */
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    
    /**
     *  Array containing menu options
     */
    var arrayMenuOptions = [Dictionary<String,String>]()
    var arrayMenu1Options = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    /**
     *  Delegate of the MenuVC
     */
    var delegate : SlideMenuDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblMenuOptions.tableFooterView = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0)
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            updateArrayMenuOptions()
        }else {
            updateArrayMenu1Options()
        }
        
        
    }
    
    @IBAction func backBtnClicked(_ button:UIButton!) {
        
        btnMenu.tag = 0
        // self.tabBarController.isHidden = false
        if (self.delegate != nil) {
            
            var index = Int32(button.tag)
            
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func updateArrayMenuOptions(){
        
        arrayMenuOptions.append(["title":"Home", "icon":"home"])
        arrayMenuOptions.append(["title":"Addresses", "icon":"storeLocater"])
        arrayMenuOptions.append(["title":"Store Locator", "icon":"storeLocater"])
        arrayMenuOptions.append(["title":"My Orders", "icon":"myorders"])
        arrayMenuOptions.append(["title":"My Profile", "icon":"profile"])
        arrayMenuOptions.append(["title":"My Wishlist", "icon":"Group 457"])
        arrayMenuOptions.append(["title":"Restaurant Owners", "icon":"resturent"])
        arrayMenuOptions.append(["title":"About Us", "icon":"5-1"])
        arrayMenuOptions.append(["title":"Contact", "icon":"contact"])
        arrayMenuOptions.append(["title":"FAQs", "icon":""])
        arrayMenuOptions.append(["title":"Policies", "icon":""])
        arrayMenuOptions.append(["title":"Terms and Conditions", "icon":""])
        arrayMenuOptions.append(["title":"Log Out", "icon":"login"])
        
        tblMenuOptions.reloadData()
        
    }
    
    func updateArrayMenu1Options(){
        
        arrayMenu1Options.append(["title":"Log In", "icon":"login"])
        arrayMenu1Options.append(["title":"Home", "icon":"home"])
        arrayMenu1Options.append(["title":"Store Locator", "icon":"storeLocater"])
        arrayMenu1Options.append(["title":"Restaurant Owners", "icon":"resturent"])
        arrayMenu1Options.append(["title":"About Us", "icon":"5-1"])
        arrayMenu1Options.append(["title":"Contact", "icon":"contact"])
        arrayMenu1Options.append(["title":"FAQs", "icon":""])
        arrayMenu1Options.append(["title":"Policies", "icon":""])
        arrayMenu1Options.append(["title":"Terms and Conditions", "icon":""])
        
        tblMenuOptions.reloadData()
        
    }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
        
        btnMenu.tag = 0
        
        if (self.delegate != nil) {
            var index = Int32(button.tag)
            if(button == self.btnCloseMenuOverlay){
                index = -1
            }
            delegate?.slideMenuItemSelectedAtIndex(index)
        }
        
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: "SideMenuTableViewCell") as! SideMenuTableViewCell
        
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        cell.preservesSuperviewLayoutMargins = false
        cell.backgroundColor = UIColor.clear
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            
            cell.imgView.image = UIImage(named: arrayMenuOptions[indexPath.row]["icon"]!)
            cell.tielLbl.text = arrayMenuOptions[indexPath.row]["title"]!
            
            if arrayMenuOptions[indexPath.row]["title"] == "Restaurant Owners" || arrayMenuOptions[indexPath.row]["title"] == "Terms and Conditions"
            {
                cell.bottomView.isHidden = false
            } else {
                cell.bottomView.isHidden = true
            }
            
            if arrayMenuOptions[indexPath.row]["icon"] == ""{
                cell.imgViewWidhtConstant.constant = 0
            } else {
                cell.imgViewWidhtConstant.constant = 25
            }
            
        }else {
            cell.imgView.image = UIImage(named: arrayMenu1Options[indexPath.row]["icon"]!)
            cell.tielLbl.text = arrayMenu1Options[indexPath.row]["title"]!
            
            if arrayMenu1Options[indexPath.row]["title"] == "Log In" || arrayMenu1Options[indexPath.row]["title"] == "Restaurant Owners" || arrayMenu1Options[indexPath.row]["title"] == "Contact"
            {
                cell.bottomView.isHidden = false
            } else {
                cell.bottomView.isHidden = true
            }
            
            if arrayMenu1Options[indexPath.row]["icon"] == "" {
                cell.imgViewWidhtConstant.constant = 0
            } else {
                cell.imgViewWidhtConstant.constant = 25
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let btn = UIButton(type: UIButton.ButtonType.custom)
        btn.tag = indexPath.row
        self.onCloseMenuClick(btn)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            return arrayMenuOptions.count
        }else {
            return arrayMenu1Options.count
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
}
