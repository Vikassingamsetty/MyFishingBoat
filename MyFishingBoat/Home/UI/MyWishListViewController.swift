//
//  AddressListViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class MyWishListViewController : BaseViewController,UITextFieldDelegate {
    
    @IBOutlet weak var myWishListTableView: UITableView!
    @IBOutlet weak var homeBtnOutlet: UIButton!
    @IBOutlet weak var mainView: UIView!
    
    //Models
    var wishlistList: WishlistListModel?
    var cartListModel:CartListModel?
    
    var count = Int()
    var sum = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeBtnOutlet.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        myWishListTableView.estimatedRowHeight = 160
        myWishListTableView.rowHeight = UITableView.automaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if UserDefaults.standard.string(forKey: "userid") != nil {
            if Reachability.isConnectedToNetwork() {
                userWishList()
                cartTotal()
            }else{
                showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
            }
        }else{
            let vc = storyboard?.instantiateViewController(identifier: "BeforeLoginVC") as! BeforeLoginVC
            addChild(vc)
            mainView.addSubview(vc.view)
            vc.view.frame = mainView.frame
            vc.didMove(toParent: self)
        }
        
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey:"FromTab") == "Yes" {
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }else{
            dismiss(animated:false)
        }
    }
    
    //MARK:- API calls
    //wishlist list items
    func userWishList() {
        count = 0
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: listWishlist_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else {return}
            
            guard let responseJson = try? JSONDecoder().decode(WishlistListModel.self, from: response) else{return}
            
            if responseJson.status == 200 {
                self.wishlistList = responseJson
                print(responseJson.data.count)
                
                DispatchQueue.main.async {
                    if responseJson.data.count != 0 {
                        self.tabBarController?.tabBar.items?[2].badgeValue = "\(responseJson.data.count)"
                    }
                    self.count = responseJson.data.count
                    self.myWishListTableView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                print(responseJson.message)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1) {
                    if responseJson.data.count != 0 {
                        self.tabBarController?.tabBar.items?[2].badgeValue = "\(responseJson.data.count)"
                    }else{
                        self.tabBarController?.tabBar.items?[2].badgeValue = nil
                    }
                    self.myWishListTableView.reloadData()
                }
            }
        }) { (error) in
            print(error.localizedDescription)
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Remove wishlist
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
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
                DispatchQueue.main.asyncAfter(deadline: .now()+2.1, execute: {
                    self.userWishList()
                    self.myWishListTableView.reloadData()
                })
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //Total items in cart
    func cartTotal() {
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid":uid
        ]
        
        RestService.serviceCall(url: cartList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(CartListModel.self, from: response) else {return}
            self.cartListModel = responseJson
            
            if responseJson.status == 200 {
                
                if responseJson.data!.count != 0 {
                    self.tabBarController?.tabBar.items?[3].badgeValue = "\(responseJson.data!.count)"
                }
                
            }else{
                //showAlertMessage(vc: self, titleStr: "", messageStr: self.cartListModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
}

extension MyWishListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : MyWishListTableViewCell = self.myWishListTableView.dequeueReusableCell(withIdentifier: "MyWishListTableViewCell") as! MyWishListTableViewCell
        
        cell.selectionStyle = .none
        cell.imgView.sd_setImage(with: URL(string: (wishlistList?.data[indexPath.row].imageIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))!), placeholderImage: UIImage(named: ""))
        cell.amountLbl.text = wishlistList?.data[indexPath.row].productPrice
        cell.quantityLbl.text = wishlistList?.data[indexPath.row].productWeight
        cell.titleLbl.text = wishlistList?.data[indexPath.row].productName
        
        cell.addToCart.tag = indexPath.row
        cell.addToCart.addTarget(self, action: #selector(addToCartBtnAction(_:)), for: .touchUpInside)
        
        cell.favBtnOutlet.tag = indexPath.row
        cell.favBtnOutlet.setImage(#imageLiteral(resourceName: "selected"), for: .normal)
        cell.favBtnOutlet.addTarget(self, action: #selector(removeFromWishlist(_:)), for: .touchUpInside)
        
        if wishlistList?.data[indexPath.row].stockStatus == "0" {
            cell.outOfStockLbl.isHidden = false
            cell.addToCart.isUserInteractionEnabled = false
        }else{
            cell.outOfStockLbl.isHidden = true
            cell.addToCart.isUserInteractionEnabled = true
        }
        
        
        return cell
    }
    
    @objc func removeFromWishlist(_ sender: UIButton){
        
        if Reachability.isConnectedToNetwork() {
            removeWishlist(pro_id: wishlistList!.data[sender.tag].productID ?? "", catg_id: wishlistList!.data[sender.tag].catID ?? "")
            
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
       
    }
    
    @objc func addToCartBtnAction(_ sender: UIButton){
        //add to cart options
        if UserDefaults.standard.string(forKey: "userid") != nil{
            let vc = storyboard?.instantiateViewController(identifier: "AddToCartPopupVC") as! AddToCartPopupVC
            vc.modalPresentationStyle = .overCurrentContext
            vc.cid = wishlistList!.data[sender.tag].cid ?? ""
            vc.pid = wishlistList!.data[sender.tag].productID ?? ""
            vc.price = wishlistList!.data[sender.tag].productPrice ?? ""
            vc.gettingFrom = "wishlist"
            vc.delegate = self
            present(vc, animated: false, completion: nil)
        }else{
            showAlertMessage(vc: self, titleStr: "", messageStr: "Login/Signup to add to cart")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(identifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.modalPresentationStyle = .fullScreen
        vc.cid = wishlistList!.data[indexPath.row].cid ?? ""
        vc.pid = wishlistList!.data[indexPath.row].productID ?? ""
        present(vc, animated: false, completion: nil)
    }
    
}

extension MyWishListViewController: AddCartProtocol {
    
    func didTapCart(tagValue: String) {
        DispatchQueue.main.async {
            self.userWishList()
            self.cartTotal()
        }
    }
    
}
