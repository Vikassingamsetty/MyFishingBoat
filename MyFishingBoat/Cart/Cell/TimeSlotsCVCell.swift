//
//  TimeSlotsCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 21/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class TimeSlotsCVCell: UICollectionViewCell {

    static let identifier = "TimeSlotsCVCell"
    
    static func nib() -> UINib {
        return UINib(nibName: "TimeSlotsCVCell", bundle: nil)
    }
    
    @IBOutlet weak var displayView: UIView!
    @IBOutlet weak var timeLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        displayView.layer.borderColor = #colorLiteral(red: 0.4274509804, green: 0.4352941176, blue: 0.4470588235, alpha: 1)
        displayView.layer.cornerRadius = 10
        displayView.layer.borderWidth = 2
    
        // Initialization code
    }
    
}
