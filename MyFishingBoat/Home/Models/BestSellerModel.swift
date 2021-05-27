//
//  BestSellerModel.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 29/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct BestSellerModel: Codable {
    
    let status: Int
    let message: String
    let data: [DataBestSeller]?
}

// MARK: - Datum
struct DataBestSeller: Codable {
    let id, productName, productPrice, productWeight: String?
    let priceDescription, productQty, productStatus, stockStatus: String?
    let productPhotos: String?
    let productDiscription, catID, facts, healthBenefits: String?
    let recipes: String?
    let imageIos: String?
    let imageAnd: String?
    let wishlist, cart, quantity: String?

    enum CodingKeys: String, CodingKey {
        case id
        case productName = "product_name"
        case productPrice = "product_price"
        case productWeight = "product_weight"
        case priceDescription = "price_description"
        case productQty = "product_qty"
        case productStatus = "product_status"
        case stockStatus = "stock_status"
        case productPhotos = "product_photos"
        case productDiscription = "product_discription"
        case catID = "cat_id"
        case facts
        case healthBenefits = "health_benefits"
        case recipes
        case imageIos = "image_ios"
        case imageAnd = "image_and"
        case wishlist, cart, quantity
    }
}
