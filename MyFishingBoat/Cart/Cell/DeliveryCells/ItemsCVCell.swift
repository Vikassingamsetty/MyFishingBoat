//
//  ItemsCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 21/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class ItemsCVCell: UICollectionViewCell {

    static let identifier = "ItemsCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "ItemsCVCell", bundle: nil)
    }
    
    @IBOutlet weak var itemNameLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var gstLbl: UILabel!
    @IBOutlet weak var subTotalLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
