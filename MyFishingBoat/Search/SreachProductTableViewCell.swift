//
//  SreachProductTableViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 20/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class SreachProductTableViewCell: UITableViewCell {

    @IBOutlet weak var SreachProductDeslbl: UILabel!
    @IBOutlet weak var SreachProductGramslbl: UILabel!
    @IBOutlet weak var SreachProductPriceLbl: UILabel!
    @IBOutlet weak var SreachProductName: UIButton!
    @IBOutlet weak var SreachProductImgVw: UIImageView!
    @IBOutlet weak var stockAvailLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SreachProductImgVw.contentMode = .scaleToFill
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
  
}
