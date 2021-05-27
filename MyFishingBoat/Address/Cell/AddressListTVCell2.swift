//
//  AddressListTVCell2.swift
//  MyFishingBoat
//
//  Created by Vikas on 30/01/21.
//

import UIKit

class AddressListTVCell2: UITableViewCell {

    class var identifier: String {
        return "\(self)"
    }
    
    @IBOutlet weak var addNewAddrBtn: UIButton!
    @IBOutlet weak var storeLocationBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
