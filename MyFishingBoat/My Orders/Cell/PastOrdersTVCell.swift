//
//  PastOrdersTVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 16/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class PastOrdersTVCell: UITableViewCell {
    
    static let identifier = "PastOrdersTVCell"
    static func nib() -> UINib {
        return UINib(nibName: "PastOrdersTVCell", bundle: nil)
    }

    @IBOutlet weak var pastOrderNumberLbl: UILabel!
    @IBOutlet weak var pastDeliveryDateLbl: UILabel!
    @IBOutlet weak var pastTotalItemsLbl: UILabel!
    @IBOutlet weak var pastTotalAmountLbl: UILabel!
    @IBOutlet weak var viewDetailsBtn: UIButton!
    @IBOutlet weak var orderTypeStatus: UIButton! //delivered or cancelled
    
    
    var delegateTap: TapOnOrderButtonDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        viewDetailsBtn.layer.cornerRadius = 15.0
        viewDetailsBtn.layer.borderWidth = 1.0
        viewDetailsBtn.layer.borderColor = UIColor.colorFromHex("#48494B").cgColor
        viewDetailsBtn.addTarget(self, action: #selector(didTapOnOrderDetails), for: .touchUpInside)
        // Initialization code
    }
  
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
    @objc func didTapOnOrderDetails(_ sender: UIButton) {
        delegateTap?.didTapOnOrderButton(tapValue: sender.tag)
    }
    
}

protocol TapOnOrderButtonDelegate {
    func didTapOnOrderButton(tapValue: Int)
}
