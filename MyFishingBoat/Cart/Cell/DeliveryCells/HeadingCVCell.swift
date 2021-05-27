//
//  HeadingCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 21/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class HeadingCVCell: UICollectionViewCell {

    static let identifier = "HeadingCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "HeadingCVCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
