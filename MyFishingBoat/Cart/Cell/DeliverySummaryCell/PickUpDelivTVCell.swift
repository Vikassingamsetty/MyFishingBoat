//
//  PickUpDelivTVCell.swift
//  MyFishingBoat
//
//  Created by vikas on 06/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class PickUpDelivTVCell: UITableViewCell {
    
    static let identifier = "PickUpDelivTVCell"
    static func nib() -> UINib {
        return UINib(nibName: "PickUpDelivTVCell", bundle: nil)
    }
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productDescp: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.contentMode = .scaleToFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
