//
//  LiveOrdersViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 23/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class PastordersViewController: UIViewController{
    
    let pastOrdersTableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsVerticalScrollIndicator = false
        table.register(PastOrdersTVCell.nib(), forCellReuseIdentifier: PastOrdersTVCell.identifier)
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        return table
    }()
   
    //Model
    var pastOrdersModel:PastOrdersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pastOrdersTableView.delegate = self
        pastOrdersTableView.dataSource = self
    }

    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(pastOrdersTableView)
        pastOrdersTableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            serverCall()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
        pastOrdersTableView.reloadData()
    }
    
    func serverCall() {
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
                DispatchQueue.main.async {
                    self.pastOrdersTableView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.pastOrdersModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
    
    
}

extension PastordersViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = pastOrdersModel?.data!.count {
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = pastOrdersTableView.dequeueReusableCell(withIdentifier: PastOrdersTVCell.identifier, for: indexPath) as? PastOrdersTVCell else {return UITableViewCell()}
        
        let orders = pastOrdersModel?.data?[indexPath.row]
        
        cell.pastOrderNumberLbl.text = "\(orders?.orderID ?? "")"
        let dates = orders?.deliveryDate ?? ""
        let times = orders?.deliveryTime ?? ""
        cell.pastDeliveryDateLbl.text = dates+" "+times
        cell.pastTotalItemsLbl.text = pastOrdersModel?.data?[indexPath.row].itemCount ?? ""
        cell.pastTotalAmountLbl.text = "₹ \(orders?.total ?? "")"
        cell.orderTypeStatus.setTitle(orders!.orderStatus ?? "", for: .normal)
        cell.viewDetailsBtn.tag = indexPath.row
        
        cell.selectionStyle = .none
        cell.delegateTap = self
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
}

//Protocol declaration
extension PastordersViewController: TapOnOrderButtonDelegate {
    
    func didTapOnOrderButton(tapValue: Int) {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(identifier: "DetailsOfPastOrderViewController") as! DetailsOfPastOrderViewController
        vc.modalPresentationStyle = .fullScreen
        vc.orderNumb = pastOrdersModel?.data?[tapValue].orderID ?? ""
        
        print(pastOrdersModel!.data![tapValue].orderID, "order id")
        self.present(vc, animated: false, completion: nil)
    }
    
}
