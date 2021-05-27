//
//  AddCartTableViewCell.swift
//  MyFishingBoat
//
//  Created by vikas on 30/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class AddCartTableViewCell: UITableViewCell {

    static let identifier = "AddCartTableViewCell"
    static func nib() -> UINib{
        return UINib(nibName: "AddCartTableViewCell", bundle: nil)
    }
    
    @IBOutlet weak var cuttingTypeLbl: UILabel!
    @IBOutlet weak var imagePref: UIImageView!
    @IBOutlet weak var selectBtn: UIButton!
    @IBOutlet weak var displayView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
