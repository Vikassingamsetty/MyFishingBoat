//
//  DeliveryAddrListVC.swift
//  MyFishingBoat
//
//  Created by Vikas on 29/12/20.
//

import UIKit

class DeliveryAddrListVC: UIViewController {

    @IBOutlet weak var table: UITableView!
    
    var deliveryAddrModel:DeliveryAddrModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.estimatedRowHeight = 80
        table.rowHeight = UITableView.automaticDimension
        
        if Reachability.isConnectedToNetwork() {
            deliveryAreasAPI()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    //MARK:- selector
    //back btn
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    //store location
    @IBAction func onTapStoreLocation(_ sender: Any) {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "StoreLocaterViewController") as! StoreLocaterViewController
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    //MARK:-API
    func deliveryAreasAPI() {
        
        RestService.serviceCall(url: deliveryAreas_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self) {[weak self] (response) in
            guard let self = self else{return}
            
            guard let responseJson = try? JSONDecoder().decode(DeliveryAddrModel.self, from: response) else{return}
            self.deliveryAddrModel = responseJson
            if responseJson.status == 200 {
                DispatchQueue.main.async {[weak self] in
                    self?.table.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        } failure: { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension DeliveryAddrListVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return deliveryAddrModel?.data?.count ?? 0
        }else{
            return 1
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 0 {
            let cell = table.dequeueReusableCell(withIdentifier: DeliveryAddrTVCell.identifier, for: indexPath) as! DeliveryAddrTVCell
            cell.addressLbl.text = deliveryAddrModel?.data?[indexPath.row].areaName ?? ""
            return cell
        }else if indexPath.section == 1 {
            let cell = table.dequeueReusableCell(withIdentifier: DeliveryAddrTVCell2.identifier, for: indexPath) as! DeliveryAddrTVCell2
            cell.storeLocationBtn.addTarget(self, action: #selector(onTapStoreLocationBtn), for: .touchUpInside)
            cell.titleLbl.text = "If you didn't find your locality then"
            return cell
        }
        return UITableViewCell()
        
    }
    
    //Nearest Stores
    @objc func onTapStoreLocationBtn() {
        
        let vc = storyboard?.instantiateViewController(identifier: "StoreLocaterViewController") as! StoreLocaterViewController
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        table.deselectRow(at: indexPath, animated: true)
        
        if indexPath.section == 0 {
            let vc = storyboard?.instantiateViewController(identifier: "SMTabbarController") as! SMTabbarController
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false, completion: nil)
        }
        
    }
    
}
