//
//  AddresshDetailsCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class AddresshDetailsCVCell: UICollectionViewCell {
    
    static let identifier = "AddresshDetailsCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "AddresshDetailsCVCell", bundle: nil)
    }

    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var dateofDeliveryLbl: UILabel!
    @IBOutlet weak var paymentTypeLbl: UILabel!
    @IBOutlet weak var deliveredAddrLbl: UILabel!
    
    @IBOutlet weak var deliveryStaticLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
