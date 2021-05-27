//
//  LiveOrdersViewController.swift
//  MyFishingBoat
//
//  Created by Appcare on 23/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class LiveOrdersViewController: UIViewController{
    
    private let liveOrdersTableView:UITableView = {
        let table = UITableView(frame: .zero, style: .plain)
        table.showsVerticalScrollIndicator = false
        table.register(LiveOrdersTVCell.nib(), forCellReuseIdentifier: LiveOrdersTVCell.identifier)
        table.separatorStyle = .none
        table.tableFooterView = UIView()
        return table
    }()
    
    var liveOrdersModel:LiveOrdersModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        displayDetails()
    }
    
    func displayDetails() {
     
        liveOrdersTableView.delegate = self
        liveOrdersTableView.dataSource = self
        
        serverCall()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        view.addSubview(liveOrdersTableView)
        liveOrdersTableView.frame = view.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        liveOrdersTableView.reloadData()
    }
    
    //APICALL
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
                DispatchQueue.main.async {
                    self.liveOrdersTableView.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: self.liveOrdersModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
        
    }
}

extension LiveOrdersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let count = liveOrdersModel?.data!.count {
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = liveOrdersTableView.dequeueReusableCell(withIdentifier: LiveOrdersTVCell.identifier, for: indexPath) as? LiveOrdersTVCell else {return UITableViewCell()}
        
        let order = liveOrdersModel?.data![indexPath.row]
        
        cell.orderNumberLbl.text = order?.orderID ?? ""
        cell.totalAmountLbl.text = "₹ \(order?.total ?? "")"
        cell.totalItemsLbl.text = liveOrdersModel?.data?[indexPath.row].itemCount ?? ""
        cell.orderStatusBtn.tag = indexPath.row
            
        cell.selectionStyle = .none
        cell.tapOnButtonDelegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
}

extension LiveOrdersViewController: TapOnButtonDelegate {
   
    func didTapOnButton(tapValue: Int) {
        let mainStoryBoard = UIStoryboard.init(name: "Main", bundle: nil)
        let vc = mainStoryBoard.instantiateViewController(identifier: "NotificationsViewController") as! NotificationsViewController
        UserDefaults.standard.set(liveOrdersModel!.data![tapValue].orderID, forKey: "orderid")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
}
