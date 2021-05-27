//
//  ProductsListCollectionViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 26/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

//
//  BestSellersCollectionViewCell.swift
//  MyFishingBoat
//
//  Created by Appcare on 18/06/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import UIKit

class ProductsListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var amountLbl: UILabel!
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var outOfStockLbl: UILabel!
    
    @IBOutlet weak var addToCartBtn: CustomButton!
    @IBOutlet weak var favouriteBtnOutlet: UIButton!
    @IBOutlet weak var minValueBtn: UIButton!
    @IBOutlet weak var quantityBtn: UIButton!
    @IBOutlet weak var maxValueBtn: UIButton!
    
    var productID:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleToFill
        outOfStockLbl.isHidden = true
    }
    
    
    func configProductList(list:ProductListByCategory, index:Int) {
        titleLbl.text = list.data?[index].productName ?? ""
        subTitleLbl.text = list.data?[index].productDiscription?.html2String ?? ""
        amountLbl.text = list.data?[index].productPrice ?? ""
        quantityLbl.text = list.data?[index].productWeight ?? ""
    }
    
}
