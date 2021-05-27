//
//  NotificationOrderStatusVC.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

struct OrderPreparation {
    let image: UIImage
    let titlePreparation:String
    let subTitlePreparation:String
}

class NotificationOrderStatusVC: UIViewController {
    
    private let table:UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(MapTVCell.nib(), forCellReuseIdentifier: MapTVCell.identifier)
        tableView.register(orderPreparationStatusTVCell.nib(), forCellReuseIdentifier: orderPreparationStatusTVCell.identifier)
        return tableView
    }()
    
    var dataArray:[OrderPreparation] = [] // delivery
    var dataArray1:[OrderPreparation] = [] //pickup
    var pastOrderDetailsModel:PastOrderDetailsModel?
    //var orderStatusModel:OrderStatusModel?
    
    var cont = 0
    var numb = String()
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        table.estimatedRowHeight = table.rowHeight
        table.rowHeight = UITableView.automaticDimension
        table.tableFooterView = UIView()
        
        dataArray.append(contentsOf: [OrderPreparation(image: UIImage(named: "orderReceived1")!, titlePreparation: "ORDER RECEIVED", subTitlePreparation: "We have received your order!"),
                                      OrderPreparation(image: UIImage(named: "orderProcessing1")!, titlePreparation: "ORDER PROCESSING", subTitlePreparation: ""),
                                      OrderPreparation(image: UIImage(named: "orderPacked1")!, titlePreparation: "ORDER PACKED", subTitlePreparation: "Order Freshly Packed"),
                                      OrderPreparation(image: UIImage(named: "orderOntheway1")!, titlePreparation: "ON THE WAY", subTitlePreparation: "Your order is out for delivery"),
                                      OrderPreparation(image: UIImage(named: "orderDelivered1")!, titlePreparation: "DELIVERED", subTitlePreparation: "Your order is Delivered")])
        
        dataArray1.append(contentsOf: [OrderPreparation(image: UIImage(named: "orderReceived1")!, titlePreparation: "ORDER RECEIVED", subTitlePreparation: "We have received your order!"),
                                      OrderPreparation(image: UIImage(named: "orderProcessing1")!, titlePreparation: "ORDER PROCESSING", subTitlePreparation: ""),
                                      OrderPreparation(image: UIImage(named: "orderPacked1")!, titlePreparation: "ORDER PACKED", subTitlePreparation: "Order Freshly Packed"),
                                      OrderPreparation(image: UIImage(named: "orderReadyPickup1")!, titlePreparation: "READY FOR PICKUP", subTitlePreparation: "You can Pickup the order"),
                                      OrderPreparation(image: UIImage(named: "orderOntheway1")!, titlePreparation: "PICKED UP", subTitlePreparation: "Your order is Picked")])
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        table.frame = view.bounds
        view.addSubview(table)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Reachability.isConnectedToNetwork() {
            if UserDefaults.standard.string(forKey: "orderid") != nil {
                orderStatusDetailsAPI()
                timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(timerFunc), userInfo: nil, repeats: true)
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: "No Live Orders")
            }
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
        
    }
    
    @objc func timerFunc() {
        print("timer value 1")
        orderStatusDetailsAPI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer?.invalidate()
        
    }
    
    //API call
    //Order Details
    func orderStatusDetailsAPI() {
        
        guard let uid = UserDefaults.standard.string(forKey: "userid") else{return}
        
        let params = [
            "uid": uid,
            "order_id": UserDefaults.standard.string(forKey: "orderid")!
        ]
        
        RestService.serviceCall(url: viewOrderDetails_URL, method: .post, parameters: params, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(PastOrderDetailsModel.self, from: response) else{return}
            self.pastOrderDetailsModel = responseJson
            
            if responseJson.status == 200 {
                
                DispatchQueue.main.async {
                    self.cont = 2
                    self.table.reloadData()
                }
                
            }else{
                self.timer?.invalidate()
                showAlertMessage(vc: self, titleStr: "", messageStr: self.pastOrderDetailsModel!.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension NotificationOrderStatusVC: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return cont
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0{
            return 1
        }else{
            if pastOrderDetailsModel!.data[0].deliveryType == "delivery" {
                return dataArray.count
            }else{
                return dataArray1.count
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0{
            guard let cell = table.dequeueReusableCell(withIdentifier: MapTVCell.identifier, for: indexPath) as? MapTVCell else {return UITableViewCell()}
            
            cell.orderNumberLbl.text = pastOrderDetailsModel!.data[0].orderID
            cell.latLngValues(values: pastOrderDetailsModel!)
            
            return cell
        }else{
            guard let cell = table.dequeueReusableCell(withIdentifier: orderPreparationStatusTVCell.identifier, for: indexPath) as? orderPreparationStatusTVCell else {return UITableViewCell()}
            
            print("timer value 2")
            
            if pastOrderDetailsModel!.data[0].deliveryType == "delivery" {
                
                cell.orderPreparationImage.image = dataArray[indexPath.row].image
                cell.orderPreparationStatusLbl.text = dataArray[indexPath.row].titlePreparation
                cell.orderPreparationSubStatusLbl.text = dataArray[indexPath.row].subTitlePreparation
                cell.hereOrderProcessingBtn.isHidden = true
                
                if pastOrderDetailsModel!.data[0].orderStatus == "Order_Received" {
                    if indexPath.row == 0 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Processing" {
                    if indexPath.row == 1 {
//                        cell.hereOrderProcessingBtn.isHidden = false
//                        cell.hereOrderProcessingBtn.addTarget(self, action: #selector(liveStreamBtn), for: .touchUpInside)
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Packed" {
                    if indexPath.row == 2 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Onthe_Way" {
                    if indexPath.row == 3 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Delivered" {
                    if indexPath.row == 4 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }
                
            }else{
                cell.orderPreparationImage.image = dataArray1[indexPath.row].image
                cell.orderPreparationStatusLbl.text = dataArray1[indexPath.row].titlePreparation
                cell.orderPreparationSubStatusLbl.text = dataArray1[indexPath.row].subTitlePreparation
                cell.hereOrderProcessingBtn.isHidden = true
                
                if pastOrderDetailsModel!.data[0].orderStatus == "Order_Received" {
                    if indexPath.row == 0 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Processing" {
                    if indexPath.row == 1 {
//                        cell.hereOrderProcessingBtn.isHidden = false
//                        cell.hereOrderProcessingBtn.addTarget(self, action: #selector(liveStreamBtn), for: .touchUpInside)
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Packed" {
                    if indexPath.row == 2 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Ready_to_pickup" {
                    if indexPath.row == 3 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }else if pastOrderDetailsModel!.data[0].orderStatus == "Order_Pickedup" {
                    if indexPath.row == 4 {
                        cell.orderPreparationStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                        cell.orderPreparationSubStatusLbl.textColor = #colorLiteral(red: 0, green: 0.1137254902, blue: 0.6117647059, alpha: 1)
                    }
                }
                
            }
            
            return cell
        }
        
    }
    
    //live streaming
    @objc func liveStreamBtn() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "LiveStreamingVC") as! LiveStreamingVC
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
}
