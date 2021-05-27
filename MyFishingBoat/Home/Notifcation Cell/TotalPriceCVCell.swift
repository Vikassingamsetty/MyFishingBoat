//
//  TotalPriceCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class TotalPriceCVCell: UICollectionViewCell {

    static let identifier = "TotalPriceCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "TotalPriceCVCell", bundle: nil)
    }
    
    @IBOutlet weak var itemTotalLbl: UILabel!
    @IBOutlet weak var deliveryChargedLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var netTotalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
