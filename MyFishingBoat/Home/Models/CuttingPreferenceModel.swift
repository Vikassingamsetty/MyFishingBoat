//
//  CuttingPreferenceModel.swift
//  MyFishingBoat
//
//  Created by vikas on 30/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
//struct CuttingPreferenceModel: Codable {
//    
//    let status: Int
//    let message: String
//    let data: [DataCuttingPref]
//}
//
//struct DataCuttingPref: Codable {
//    let id, type, image: String?
//}

// MARK: -  Cutting Preference new model

struct CuttingPreferencesModel: Codable {
    let status: Int
    let message: String
    let data: [DataCuttingPreference]?
}

// MARK: - Datum
struct DataCuttingPreference: Codable {
    let id, productName, productPrice, priceDescription: String?
    let quantityDescription, productWeight, productQty, productStatus: String?
    let stockStatus, productPhotos, productDiscription, catID: String?
    let cuttingID, facts, healthBenefits, recipes: String?
    let bestSellar, cd, cuttingPreferencesID, type: String?
    let image: String?
    let catName: String?
    let cuttingPreferencesData: [CuttingPreferencesDatum]?

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
        case productDiscription = "product_discription"
        case catID = "cat_id"
        case cuttingID = "cutting_id"
        case facts
        case healthBenefits = "health_benefits"
        case recipes
        case bestSellar = "best_sellar"
        case cd
        case cuttingPreferencesID = "cutting_preferences_id"
        case type, image
        case catName = "cat_name"
        case cuttingPreferencesData = "cutting_preferences_data"
    }
}

// MARK: - CuttingPreferencesDatum
struct CuttingPreferencesDatum: Codable {
    let type, cuttingPreferencesID: String?
    let image, image_ios, image_and: String?

    enum CodingKeys: String, CodingKey {
        case type
        case cuttingPreferencesID = "cutting_preferences_id"
        case image
        case image_and
        case image_ios
    }
}


//MARK:- add to cart update API
struct AddToCartBtnModel: Codable {
    let status: Int
    let message:String
    let data: CartAdd?
}
struct CartAdd: Codable {
    let uid, pid, cid, price: String?
    let quantity, status: String?
}
