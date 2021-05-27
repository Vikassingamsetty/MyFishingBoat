//
//  CartListModel.swift
//  MyFishingBoat
//
//  Created by vikas on 03/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
//MARK:- CartList
struct CartListModel: Codable {
    let status: Int
    let message: String
    let data: [DataCart]?
}

// MARK: - Datum
struct DataCart: Codable {
    let id, productName, productPrice, priceDescription: String?
    let quantityDescription, productWeight, productQty, productStatus: String?
    let stockStatus: String?
    let productPhotos: String?
    let productDiscription, catID, cuttingID, facts: String?
    let healthBenefits, recipes, bestSellar, cd: String?
    let uid, pid, cid, price: String?
    let quantity, status, type: String?
    let image: String?
    let cuttingPreferencesData: [CuttingPreferencesCart]?

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
        case cd, uid, pid, cid, price, quantity, status, type, image
        case cuttingPreferencesData = "cutting_preferences_data"
    }
}

// MARK: - CuttingPreferencesDatum
struct CuttingPreferencesCart: Codable {
    let type, cuttingPreferencesID, cuttingPreferencesImage, image: String?

    enum CodingKeys: String, CodingKey {
        case type
        case cuttingPreferencesID = "cutting_preferences_id"
        case cuttingPreferencesImage = "cutting_preferences_image"
        case image
    }
}




//Remove from cart
struct RemoveCartModel:Codable {
    let status:Int
    let message:String
}

//Remove from cart
struct RemovCartModel:Codable {
    let status:Int
    let message:String
}


//Gst and charges
struct DeliveryChargesModel: Codable {
    let status: Int
    let message: String
    let data: [DataDelv]?
}

// MARK: - Datum
struct DataDelv: Codable {
    let id, gst, deliveryCharge: String?
    //let cd: JSONNull?
    
    enum CodingKeys: String, CodingKey {
        case id, gst
        case deliveryCharge = "delivery_charge"
        //case cd
    }
}

//Delivery Type List
struct DeliveryTypeList: Codable {
    
    let status: Int
    let message: String
    let data: [DataDeliveryList]?
}

// MARK: - Datum
struct DataDeliveryList: Codable {
   let id, type: String?
   let image: String?
   let imageIos: String?
   let imageAnd: String?
   let status, alert: String?

   enum CodingKeys: String, CodingKey {
       case id, type, image
       case imageIos = "image_ios"
       case imageAnd = "image_and"
       case status, alert
   }
}
