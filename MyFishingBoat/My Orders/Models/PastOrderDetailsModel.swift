//
//  PastOrderDetailsModel.swift
//  MyFishingBoat
//
//  Created by vikas on 17/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct PastOrderDetailsModel: Codable {
    let status: Int
    let message: String
    let data: [DataPastDe]
}

// MARK: - Datum
struct DataPastDe: Codable {
    let id, orderID, uid, productID: String?
    let price, weight, quantity, addressID: String?
    let storeID, paymentType, paymentStatus, deliveryType: String?
    let orderStatus, orderAmount, discount, mobile: String?
    let cd, cuttingPreferances, deliveryBoyID, deliveryDate: String?
    let deliveryTime, total, deliveryCharge, gst: String?
    let productName, productPrice, priceDescription, productWeight: String?
    let productQty, productStatus, stockStatus: String?
    let productPhotos: String?
    let productDiscription, catID, facts, healthBenefits: String?
    let recipes, bestSellar, userAdreesID, addressType: String?
    let address, street, flotNo, landMark: String?
    let pincode, ltd, lng, type: String?
    let image: String?
    let status, storename, storeaddress, storePincode: String?
    let stroreLandmark, storeLat, storeLng, storeEmail: String?
    let storePhone, dbLtd, dbLng, dbMobile: String?
    let dbUid: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case uid
        case productID = "product_id"
        case price, weight, quantity
        case addressID = "address_id"
        case storeID = "store_id"
        case paymentType = "payment_type"
        case paymentStatus = "payment_status"
        case deliveryType = "delivery_type"
        case orderStatus = "order_status"
        case orderAmount = "order_amount"
        case discount, mobile, cd
        case cuttingPreferances = "cutting_preferances"
        case deliveryBoyID = "delivery_boy_id"
        case deliveryDate = "delivery_date"
        case deliveryTime = "delivery_time"
        case total
        case deliveryCharge = "delivery_charge"
        case gst
        case productName = "product_name"
        case productPrice = "product_price"
        case priceDescription = "price_description"
        case productWeight = "product_weight"
        case productQty = "product_qty"
        case productStatus = "product_status"
        case stockStatus = "stock_status"
        case productPhotos = "product_photos"
        case productDiscription = "product_discription"
        case catID = "cat_id"
        case facts
        case healthBenefits = "health_benefits"
        case recipes
        case bestSellar = "best_sellar"
        case userAdreesID = "userAdreesId"
        case addressType = "address_type"
        case address, street
        case flotNo = "flot_no"
        case landMark = "land_mark"
        case pincode, ltd, lng, type
        case image, status, storename, storeaddress
        case storePincode = "store_pincode"
        case stroreLandmark = "strore_landmark"
        case storeLat = "store_lat"
        case storeLng = "store_lng"
        case storeEmail = "store_email"
        case storePhone = "store_phone"
        case dbLtd = "db_ltd"
        case dbLng = "db_lng"
        case dbMobile = "db_mobile"
        case dbUid = "db_uid"
    }
}


struct OrderStatusModel: Codable {
    let status: Int
    let message: String
    let data: [DataOrderStatus]?
}

// MARK: - Datum
struct DataOrderStatus: Codable {
    let id, title, subtitle, cd: String
    let image: String
}


