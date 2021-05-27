//
//  CartListTableViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 26/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class CartListTableViewCell: UITableViewCell {


    @IBOutlet weak var fishNameLbl: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var minusBtnOutlet: UIButton!
    
    @IBOutlet weak var plusBtnOutlet: UIButton!
    
    @IBOutlet weak var kgBtnOutlet: UIButton!
    
    @IBOutlet weak var cuttingTypeLbl: UILabel!
    
    @IBOutlet weak var moveToWishListBtnOutlet: UIButton!
    
    @IBOutlet weak var removeBtnOutlet: UIButton!
    
    @IBOutlet weak var amountBtnOutlet: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imgView.contentMode = .scaleToFill
        plusBtnOutlet.layer.cornerRadius = 0.5 * plusBtnOutlet.bounds.size.width
        plusBtnOutlet.clipsToBounds = true
        
        minusBtnOutlet.layer.cornerRadius = 0.5 * minusBtnOutlet.bounds.size.width
        minusBtnOutlet.clipsToBounds = true
    
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
