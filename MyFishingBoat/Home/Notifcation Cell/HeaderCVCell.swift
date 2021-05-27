//
//  HeaderCVCell.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 15/07/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class HeaderCVCell: UICollectionViewCell {

    static let identifier = "HeaderCVCell"
    static func nib() -> UINib {
        return UINib(nibName: "HeaderCVCell", bundle: nil)
    }
    
    @IBOutlet weak var orderNumberTitle: UILabel!
    @IBOutlet weak var orderNumberLbl: UILabel!
    @IBOutlet weak var orderStatuslbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
