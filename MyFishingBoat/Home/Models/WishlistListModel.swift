//
//  WishlistListModel.swift
//  MyFishingBoat
//
//  Created by vikas on 27/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
struct WishlistListModel:Codable {
    let status: Int
    let message: String
    let data: [DataWishList]
}

// MARK: - Datum
struct DataWishList: Codable {
   let id, productName, productPrice, priceDescription: String?
   let quantityDescription, productWeight, productQty, productStatus: String?
   let stockStatus, productPhotos, imageIos, imageAnd: String?
   let productDiscription, catID, cuttingID, facts: String?
   let healthBenefits, recipes, bestSellar, cd: String?
   let uid, productID, cid: String?

   enum CodingKeys: String, CodingKey {
       case id
       case productName = "product_name"
       case productPrice = "product_price"
       case priceDescription = "price_description"
       case quantityDescription = "quantity_description"
       case productWeight = "product_weight"
       case productQty = "product_qty"
       case productStatus = "product_status"
       case stockStatus = "stock_status"
       case productPhotos = "product_photos"
       case imageIos = "image_ios"
       case imageAnd = "image_and"
       case productDiscription = "product_discription"
       case catID = "cat_id"
       case cuttingID = "cutting_id"
       case facts
       case healthBenefits = "health_benefits"
       case recipes
       case bestSellar = "best_sellar"
       case cd, uid
       case productID = "product_id"
       case cid
   }
}
