//
//  AddToCartPopupVC.swift
//  MyFishingBoat
//
//  Created by vikas on 29/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import CoreData

protocol AddCartProtocol {
    func didTapCart(tagValue:String)
}

class AddToCartPopupVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var decBtn: UIButton!
    @IBOutlet weak var incBtn: UIButton!
    @IBOutlet weak var doneBtn: CustomButton!
    
    @IBOutlet weak var viewHeight: NSLayoutConstraint!  //177
    @IBOutlet weak var tableHeight: NSLayoutConstraint! //57
    
    var tap: UITapGestureRecognizer!
    
    //get values
    var cids = String()
    var cid = String()
    var pid = String()
    var price = String()
    var productName = String()
    var productImage = String()
    
    
    //min and max quantity change
    var quantity = 1
    var totalPrice = String()
    
    //Delegate
    var tag = Int()
    
    //Model
    //var cuttingPrefModel:CuttingPreferenceModel?
    var addToCartBtnModel:AddToCartBtnModel?
    
    var cuttingPreferencesModel: CuttingPreferencesModel?
    
    var delegate:AddCartProtocol?
    
    var selectedIndex: Int?
    
    var gettingFrom = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cids = cid
        totalPrice = price
        quantityLbl.text = "\(quantity) kg"
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
//        tableView.estimatedRowHeight = 57
//        tableView.rowHeight = UITableView.automaticDimension
        
        tableView.register(AddCartTableViewCell.nib(), forCellReuseIdentifier: AddCartTableViewCell.identifier)
        
        if Reachability.isConnectedToNetwork() {
            cuttingPreferences()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        tap = UITapGestureRecognizer(target: self, action: #selector(onTap(sender:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        tap.cancelsTouchesInView = false
        tap.delegate = self
        self.view.window?.addGestureRecognizer(tap)
    }
    
    @objc private func onTap(sender: UITapGestureRecognizer) {
        //self.view.window?.removeGestureRecognizer(sender)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func selectCuttingType(_ sender:UIButton) {

        selectedIndex = sender.tag
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @IBAction func incBtnAction(_ sender: Any) {
        if quantity > 0 {
            quantity += 1
            quantityLbl.text = "\(quantity) kg"
            totalPrice = "\(quantity * Int(price)!)"
            print(quantity, "", totalPrice, "", price)
        }
    }
    
    @IBAction func decBtnAct(_ sender: Any) {
        if quantity > 1 {
            quantity -= 1
            quantityLbl.text = "\(quantity) kg"
            totalPrice = "\(quantity * Int(price)!)"
            print(quantity, "", totalPrice, "", price)
            
        }else if quantity == 1 {
            
        }
    }
    
    func save(pname: String,prdtId:String,cids:String,qty:String,image:String,prefe:String, prefName: String,price:String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Product", in: managedContext)!
        let userName = NSManagedObject(entity: entity, insertInto: managedContext)
        userName.setValue(pname, forKeyPath: "prdtname")
        userName.setValue(prdtId, forKeyPath: "productId")
        userName.setValue(cids, forKeyPath: "categoryId")
        userName.setValue(qty, forKeyPath: "qty")
        userName.setValue(image, forKeyPath: "image")
        userName.setValue(prefe, forKeyPath: "preferences")
        userName.setValue(prefName, forKeyPath: "preferenceName")
        userName.setValue(price, forKeyPath: "price")
        var userArray: [NSManagedObject] = []
        
        do {
            try managedContext.save()
            dismiss(animated: false, completion: nil)
            self.delegate?.didTapCart(tagValue: self.cids)
            userArray.append(userName)
            print(userArray)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
    }
    
    @IBAction func doneBtnAction(_ sender: UIButton) {
        
        if selectedIndex != nil {
            if quantityLbl.text != nil {
                print(cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[selectedIndex!].cuttingPreferencesID,cids, cid, pid,"index selected")
                
                if Reachability.isConnectedToNetwork() {
                    if UserDefaults.standard.string(forKey: "userid") != nil {
                        addToCart()
                    }else{
                        print(cid, cids, pid, quantity, price, productName, productImage)
                        //coredata
                        save(pname: productName, prdtId: pid, cids: cids, qty: "\(quantity)", image: productImage, prefe: cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[selectedIndex!].cuttingPreferencesID ?? "", prefName: cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[selectedIndex!].type ?? "", price: price)
                        print(cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[selectedIndex!].cuttingPreferencesID, "index id vikas")
                    }
                }else{
                    showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "Select quantity")
            }
        }else{
            showAlertMessage(vc: self, titleStr: "", messageStr: "Select your cutting preference.")
        }
        
    }
    
    //MARK:- ApiCalls    
    func cuttingPreferences() {
        
        let params = [
            "cid": cids,
            "pid": pid
        ]
        
        print(params, "cutting preferences")
        
        RestService.serviceCall(url: cuttingPreference_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading..", vc: self) {[weak self] (response) in
            guard let self = self else {return}
            
            guard let responseJson = try? JSONDecoder().decode(CuttingPreferencesModel.self, from: response) else {return}
            
            if responseJson.status == 200 {
                self.cuttingPreferencesModel = responseJson
                
                DispatchQueue.main.async {
                    
                    self.tableHeight.constant = CGFloat(57 * (responseJson.data?[0].cuttingPreferencesData?.count ?? 0))
                    //self.viewHeight.constant = 177.0 + self.tableHeight.constant
                    print(responseJson.data?[0].cuttingPreferencesData?.count ?? 0)
                    print(self.tableHeight.constant, "table view height")
                    //print(self.viewHeight.constant, "view height")
                    self.tableView.layoutIfNeeded()
                    self.tableView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        } failure: { (error) in
            showAlertMessage(vc: self, titleStr: "", messageStr: error.localizedDescription)
        }
        
    }
    
    func addToCart() {
        
        let charSet = CharacterSet(charactersIn: " kg")
        let trim = quantityLbl.text?.trimmingCharacters(in: charSet)
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid": uid,
            "pid": pid,
            "cid": cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[selectedIndex!].cuttingPreferencesID ?? "",
            "price": totalPrice,
            "quantity": trim!
        ]
        
        print(params, "add to cart")
        
        RestService.serviceCall(url: addToCartSingle_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(AddToCartBtnModel.self, from: response) else {return}
            self.addToCartBtnModel = responseJson
            
            if responseJson.status == 200 {
                
                self.totalPrice = ""
                
                if self.gettingFrom == "wishlist" {
                    DispatchQueue.main.async {
                        print("debug")
                        self.delegate?.didTapCart(tagValue: self.cids)
                        self.removeWishlist(pro_id: self.pid, catg_id: self.cid)
                    }
                }else{
                    DispatchQueue.main.async {
                        print("debug")
                        self.delegate?.didTapCart(tagValue: self.cids)
                        self.dismiss(animated: false, completion: nil)
                    }
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.addToCartBtnModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Remove from wishlist
    func removeWishlist(pro_id:String, catg_id:String) {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "pid": pro_id,
            "cid": catg_id
        ]
        
        RestService.serviceCall(url: deleteWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(RemoveWishlist.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.dismiss(animated: false, completion: nil)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension AddToCartPopupVC: UITableViewDelegate, UITableViewDataSource {
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = cuttingPreferencesModel?.data?[0].cuttingPreferencesData?.count {
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AddCartTableViewCell.identifier, for: indexPath) as! AddCartTableViewCell
        
        cell.cuttingTypeLbl.text = cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[indexPath.row].type ?? ""
        cell.imagePref.sd_setImage(with: URL(string: (cuttingPreferencesModel?.data?[0].cuttingPreferencesData?[indexPath.row].image?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)) ?? ""), placeholderImage: UIImage(named: ""))
        cell.selectBtn.tag = indexPath.row
        cell.selectBtn.addTarget(self, action: #selector(selectCuttingType(_:)), for: .touchUpInside)
        
        
        if selectedIndex != nil {
            if selectedIndex == indexPath.row {
                cell.selectBtn.setImage(UIImage(systemName: "largecircle.fill.circle"), for: .normal)
            }else{
                cell.selectBtn.setImage(UIImage(systemName: "circle"), for: .normal)
            }
            
        }else{
            cell.selectBtn.setImage(UIImage(systemName: "circle"), for: .normal)
        }
        
        if indexPath.row == 0 || indexPath.row == 2 {
            cell.displayView.backgroundColor = #colorLiteral(red: 0.9294117647, green: 0.9333333333, blue: 0.937254902, alpha: 1)
        }
        
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 57
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

extension AddToCartPopupVC: UIGestureRecognizerDelegate {
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldReceive touch: UITouch) -> Bool {
        return (touch.view === self.view)
    }
}
