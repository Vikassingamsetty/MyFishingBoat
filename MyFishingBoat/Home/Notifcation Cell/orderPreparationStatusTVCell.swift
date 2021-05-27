//
//  orderPreparationStatusTVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class orderPreparationStatusTVCell: UITableViewCell {

    static let identifier = "orderPreparationStatusTVCell"
    static func nib() -> UINib {
        return UINib(nibName: "orderPreparationStatusTVCell", bundle: nil)
    }
    
    @IBOutlet weak var orderPreparationImage: UIImageView!
    @IBOutlet weak var orderPreparationStatusLbl: UILabel!
    @IBOutlet weak var orderPreparationSubStatusLbl: UILabel!
    @IBOutlet weak var hereOrderProcessingBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        //hereOrderProcessingBtn.isHidden = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
