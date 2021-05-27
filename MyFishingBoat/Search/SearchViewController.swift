//
//  SearchViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 17/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit
import Alamofire
import SDWebImage

class SearchViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var SreachText: UISearchBar!
    @IBOutlet weak var menuBtn: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var SreachproductTbVw: UITableView!
    @IBOutlet weak var searchButtonOutlet: UIButton!
    
    var searchProductsModel:SearchProductsModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBtn.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
        
        SreachproductTbVw.delegate = self
        SreachproductTbVw.dataSource = self
        
    }
    
    @IBAction func SreachBtnAction(_ sender: Any) {
        if UserDefaults.standard.string(forKey: "userid") != nil {
            searchProductsAPI(uid: UserDefaults.standard.string(forKey: "userid")!, productName: searchTF.text!.replacingOccurrences(of: " ", with: ""))
        }else{
            searchProductsAPI(uid: "", productName: searchTF.text!.replacingOccurrences(of: " ", with: ""))
            //showAlertMessage(vc: self, titleStr: "", messageStr: "login/signup to search the product")
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        
        //if UserDefaults.standard.string(forKey:"FromTab") == "Yes" {
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
//        }else{
//            dismiss(animated:false)
//        }
        
    }
    
    func searchProductsAPI(uid:String, productName:String) {
        
        let params = [
            "uid": uid,
            "key": productName
        ]
        print("params",params)
        RestService.serviceCall(url: searchList_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value,APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(SearchProductsModel.self, from: response) else{return}
            self.searchProductsModel = responseJson
            if responseJson.status == 200 {
                print(responseJson.data?[0].catID, "search")
                DispatchQueue.main.async {
                    self.SreachproductTbVw.reloadData()
                }
                
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
            
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    //MARK:- Tableview
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = searchProductsModel?.data?.count {
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : SreachProductTableViewCell = self.SreachproductTbVw.dequeueReusableCell(withIdentifier: "SreachProductTableViewCell") as! SreachProductTableViewCell
        
        let model = searchProductsModel!.data?[indexPath.row]
        cell.SreachProductName.setTitle(model?.productName, for: .normal)
        cell.SreachProductPriceLbl.text = model?.productPrice
        cell.SreachProductGramslbl.text = "500g"
        cell.SreachProductDeslbl.text = model?.productDiscription
        cell.SreachProductImgVw.sd_setImage(with: URL(string: model?.imageIos?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)! ?? ""), placeholderImage: UIImage(named: ""))
        
        if searchProductsModel!.data?[indexPath.row].stockStatus == "0" {
            cell.stockAvailLbl.isHidden = false
        }else{
            cell.stockAvailLbl.isHidden = true
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ProductDetailsViewController") as! ProductDetailsViewController
        vc.cid = searchProductsModel!.data?[indexPath.row].catID ?? ""
        vc.pid = searchProductsModel!.data?[indexPath.row].id ?? ""
        self.present(vc, animated: false, completion: nil)
    }
    
}


