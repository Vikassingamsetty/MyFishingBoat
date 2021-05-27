//
//  FAQVC.swift
//  MyFishingBoat
//
//  Created by vikas on 05/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class FAQVC: UIViewController {

    @IBOutlet weak var tableFAQ: UITableView!

    var expand = false
    var selectedIndex = -1
    
    var heightConstant = CGFloat()
    
    //Model
    var faqModel:FAQModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableFAQ.delegate = self
        tableFAQ.dataSource = self
        tableFAQ.estimatedRowHeight = tableFAQ.rowHeight
        tableFAQ.rowHeight = UITableView.automaticDimension
        tableFAQ.separatorStyle = .none
        tableFAQ.tableFooterView = UIView()
        
        if Reachability.isConnectedToNetwork() {
            userFaqDetails()
        }else{
            showAlertMessage(vc: self, titleStr: Network.title, messageStr: Network.message)
        }
    }
    
    @IBAction func backBtn(_ sender: Any) {
        UserDefaults.standard.setValue("No", forKey: "FromTab")
        dismiss(animated: false, completion: nil)
    }
    
    //MARK:-APi
    func userFaqDetails() {
        
        RestService.serviceCall(url: faq_URL, method: .get, parameters: nil, header: [APIKEY.key:APIKEY.value, APIKEY.contentType:APIKEY.type], isLoaded: true, title: "", message: "Loading...", vc: self, success: {[weak self] (response) in
            guard let self = self else{return}
            guard let responseJson = try? JSONDecoder().decode(FAQModel.self, from: response) else{return}
            self.faqModel = responseJson
            
            if responseJson.status == 200 {
                DispatchQueue.main.async {
                    self.tableFAQ.reloadData()
                }
            }else{
                showAlertMessage(vc: self, titleStr: "", messageStr: responseJson.message)
            }
        }) { (error) in
            showAlertMessage(vc: self, titleStr: "Alert", messageStr: error.localizedDescription)
        }
    }
    
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = faqModel?.data.count {
            return count
        }else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableFAQ.dequeueReusableCell(withIdentifier: "FAQTVCell", for: indexPath) as! FAQTVCell
        cell.questLbl.text = faqModel?.data[indexPath.row].question
        cell.answLbl.text = faqModel?.data[indexPath.row].discription
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if self.selectedIndex == indexPath.row && expand == true {
            return UITableView.automaticDimension
        }else {
            return 100
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableFAQ.dequeueReusableCell(withIdentifier: FAQTVCell.identifier, for: indexPath) as! FAQTVCell
        
        if selectedIndex == indexPath.row {
            if expand == false {
                expand = true
                cell.questLbl.textColor = #colorLiteral(red: 0.2235294118, green: 0.3529411765, blue: 1, alpha: 1)
            }else{
                expand = false
                cell.questLbl.textColor = #colorLiteral(red: 0.6235294118, green: 0.6235294118, blue: 0.6235294118, alpha: 1)
            }
        } else {
            expand = true
            cell.questLbl.textColor = #colorLiteral(red: 0.2235294118, green: 0.3529411765, blue: 1, alpha: 1)
        }
        selectedIndex = indexPath.row
        tableFAQ.reloadRows(at: [indexPath], with: .fade)
    }
    
}
