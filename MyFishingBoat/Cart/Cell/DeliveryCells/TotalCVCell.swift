//
//  TotalCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 21/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class TotalCVCell: UICollectionViewCell {

    static let identifier = "TotalCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "TotalCVCell", bundle: nil)
    }
    
    @IBOutlet weak var itemTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargedLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var finalAmountLbl: UILabel!
    
    @IBOutlet weak var paymentBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
