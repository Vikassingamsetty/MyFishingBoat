//
//  LiveOrdersTVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 16/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class LiveOrdersTVCell: UITableViewCell {

    static let identifier = "LiveOrdersTVCell"
    static func nib() -> UINib {
        return UINib(nibName: "LiveOrdersTVCell", bundle: nil)
    }
    
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderStatusBtn: UIButton!
    @IBOutlet weak var totalAmountLbl: UILabel!
    @IBOutlet weak var totalItemsLbl: UILabel!
    
    var tapOnButtonDelegate: TapOnButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        orderStatusBtn.layer.cornerRadius = 15.0
        orderStatusBtn.layer.borderWidth = 1.0
        orderStatusBtn.layer.borderColor = UIColor.colorFromHex("#48494B").cgColor
        orderStatusBtn.addTarget(self, action: #selector(orderStatusBtnAction), for: .touchUpInside)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @objc func orderStatusBtnAction(_ sender:UIButton) {
        tapOnButtonDelegate?.didTapOnButton(tapValue: sender.tag)
    }
    
}

protocol TapOnButtonDelegate {
    func didTapOnButton(tapValue:Int)
}
