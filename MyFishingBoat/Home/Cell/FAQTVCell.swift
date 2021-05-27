//
//  FAQTVCell.swift
//  MyFishingBoat
//
//  Created by vikas on 05/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class FAQTVCell: UITableViewCell {
    
    @IBOutlet weak var questViewHeight: NSLayoutConstraint!
    @IBOutlet weak var questView: CardView!
    @IBOutlet weak var questLbl: UILabel!
    @IBOutlet weak var answLbl: UILabel!
    
//    class var nibName: String {
//        return "\(self)"
//    }
    
    class var identifier: String {
        return "\(self)"
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
