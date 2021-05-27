//
//  StoreLocaterTableViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 23/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class StoreLocaterTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLbl: UIButton!
    @IBOutlet weak var distancetxt: UILabel!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var callBtnOutlet: UIButton!
    @IBOutlet weak var directionsBtnOutlet: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        distancetxt.layer.cornerRadius = 10
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
