//
//  SideMenuTableViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class SideMenuTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var imgViewWidhtConstant: NSLayoutConstraint!
    
    @IBOutlet weak var tielLbl: UILabel!
    @IBOutlet weak var bottomView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
