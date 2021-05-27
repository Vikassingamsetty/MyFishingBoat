//
//  MyWishListTableViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class MyWishListTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var favBtnOutlet: UIButton!
    @IBOutlet weak var addToCart: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var maxBtn: UIButton!
    @IBOutlet weak var weightBtn: UIButton!
    @IBOutlet weak var outOfStockLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgView.contentMode = .scaleAspectFill
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}
