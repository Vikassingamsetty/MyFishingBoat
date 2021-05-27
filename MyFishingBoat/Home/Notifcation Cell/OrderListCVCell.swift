//
//  OrderListCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class OrderListCVCell: UICollectionViewCell {

    static let identifier = "OrderListCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "OrderListCVCell", bundle: nil)
    }
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var totalQuantityLbl: UILabel!
    @IBOutlet weak var ratePerQty: UILabel!
    @IBOutlet weak var quantityPerRate: UILabel!
    @IBOutlet weak var subTotalOfEachQuantityLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
