//
//  DeliveryAddrTVCell.swift
//  MyFishingBoat
//
//  Created by Vikas on 29/12/20.
//

import UIKit

class DeliveryAddrTVCell: UITableViewCell {
    
    class var identifier: String {
        return "\(self)"
    }

    @IBOutlet weak var addressLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

}
