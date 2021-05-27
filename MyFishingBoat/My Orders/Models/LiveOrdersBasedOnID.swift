//
//  LiveOrdersBasedOnID.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 13/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct LiveOrdersModel: Codable {
    let status: Int
    let message: String
    let data: [DataLive]?
}

// MARK: - Datum
struct DataLive: Codable {
    let id, orderID, discount, total: String?
    let deliveryCharge, gst, uid, productID: String?
    let price, weight, quantity, addressID: String?
    let storeID, paymentType, paymentStatus, deliveryType: String?
    let orderStatus, orderAmount, mobile, cd: String?
    //let txnID, packingPreferances: JSONNull?
    let cuttingPreferances, deliveryDate, deliveryTime, itemCount: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case orderID = "order_id"
        case discount, total
        case deliveryCharge = "delivery_charge"
        case gst, uid
        case productID = "product_id"
        case price, weight, quantity
        case addressID = "address_id"
        case storeID = "store_id"
        case paymentType = "payment_type"
        case paymentStatus = "payment_status"
        case deliveryType = "delivery_type"
        case orderStatus = "order_status"
        case orderAmount = "order_amount"
        case mobile, cd
//        case txnID = "txn_id"
//        case packingPreferances = "packing_preferances"
        case cuttingPreferances = "cutting_preferances"
        case deliveryDate = "delivery_date"
        case deliveryTime = "delivery_time"
        case itemCount = "ItemCount"
    }
}
