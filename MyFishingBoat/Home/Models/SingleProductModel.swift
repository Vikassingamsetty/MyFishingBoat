//
//  SingleProductModel.swift
//  MyFishingBoat
//
//  Created by Appcare on 19/08/20.
//  Copyright © 2020 Anil. All rights reserved.


import Foundation

//MARK:-  Single Product details
struct SingleProductModel: Codable {
    let status: Int
    let message: String
    let data: [DataProDetails]?
}

// MARK: - Datum
struct DataProDetails: Codable {
    let id, productName, productPrice, priceDescription: String?
    let quantityDescription, productWeight, productQty, productStatus: String?
    let stockStatus: String?
    let productPhotos: String?
    let imageIos, imageAnd, productDiscription, catID: String?
    let cuttingID, facts, healthBenefits, recipes: String?
    let bestSellar, cd: String?
    let cuttingPreferencesData: [CuttingPreferencesData]?
    let wishlist, cart, quantity, cuttingPreferencesID: String?
    let image, type: String?

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
        case cuttingPreferencesData = "cutting_preferences_data"
        case wishlist, cart, quantity
        case cuttingPreferencesID = "cutting_preferences_id"
        case image, type
    }
}

// MARK: - CuttingPreferencesDatum
struct CuttingPreferencesData: Codable {
    let type, cuttingPreferencesID: String?
    let image: String?

    enum CodingKeys: String, CodingKey {
        case type
        case cuttingPreferencesID = "cutting_preferences_id"
        case image
    }
}




//MARK:-  Submit recepie
struct SubmitRecipieModel: Codable {
    let status: Bool
    let message: String
}
