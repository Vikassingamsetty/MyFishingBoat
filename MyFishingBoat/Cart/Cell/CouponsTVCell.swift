//
//  CouponsTVCell.swift
//  MyFishingBoat
//
//  Created by vikas on 05/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class CouponsTVCell: UITableViewCell {

    static var identifier = "CouponsTVCell"
    
    @IBOutlet weak var couponCodeLbl: UILabel!
    @IBOutlet weak var applyCouponBtn: UIButton!
    @IBOutlet weak var descCouponLbl: UILabel!
    @IBOutlet weak var expiresOnLbl: UILabel!
    @IBOutlet weak var totalCouponsLbl: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
