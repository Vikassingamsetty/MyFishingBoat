//
//  DatesTVCell.swift
//  MyFishingBoat
//
//  Created by vikas on 09/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class DatesTVCell: UITableViewCell {

    static let identifier = "DatesTVCell"
    
    @IBOutlet weak var datesLbl: UILabel!
    @IBOutlet weak var selectedDateBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
