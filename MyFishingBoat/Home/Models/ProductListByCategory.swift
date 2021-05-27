//
//  ProductListByCategory.swift
//  MyFishingBoat
//
//  Created by Appcare on 23/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct ProductListByCategory: Codable {
    let status: Int
    let message: String
    let data: [DataProductList]?
}

// MARK: - Datum
struct DataProductList: Codable {
    let id, productName, productPrice, priceDescription: String?
    let quantityDescription, productWeight, productQty, productStatus: String?
    let stockStatus, productPhotos, imageIos, imageAnd: String?
    let productDiscription, catID, cuttingID, facts: String?
    let healthBenefits, recipes, bestSellar, cd: String?
    let catName: String?
    let cuttingPreferencesData: [CuttingPreferencesList]?
    let wishlist, cart, quantity: String?

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
        case cd
        case catName = "cat_name"
        case cuttingPreferencesData = "cutting_preferences_data"
        case wishlist, cart, quantity
    }
}

// MARK: - CuttingPreferencesDatum
struct CuttingPreferencesList: Codable {
    let type, cuttingPreferencesID: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case type
        case cuttingPreferencesID = "cutting_preferences_id"
        case image
    }
}
