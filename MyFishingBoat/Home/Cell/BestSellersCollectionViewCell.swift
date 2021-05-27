//
//  BestSellersCollectionViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 18/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class BestSellersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var addToCartBtn: UIButton!
    @IBOutlet weak var moveToWishlistBtn: UIButton!
    @IBOutlet weak var minBtn: UIButton!
    @IBOutlet weak var maxBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var outOfStockLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleToFill
    }
    
    @IBAction func moveToWishlistAction(_ sender: Any) {
        
    }
    
    @IBAction func addToCartBtnAction(_ sender: Any) {
        
    }
    
}
