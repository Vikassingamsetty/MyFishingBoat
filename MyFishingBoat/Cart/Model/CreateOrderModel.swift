//
//  CreateOrderModel.swift
//  MyFishingBoat
//
//  Created by vikas on 12/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct DeliveryOrderModel: Codable {
    let status: Int
    let message, uid, orderID: String
    let netTotal: Int

    enum CodingKeys: String, CodingKey {
        case status, message, uid
        case orderID = "order_id"
        case netTotal = "net_total"
    }
}

struct PickupOrderModel: Codable {
    let status: Int
    let message, uid, orderID: String
    let netTotal: Int
    
    enum CodingKeys: String, CodingKey {
        case status, message, uid
        case orderID = "order_id"
        case netTotal = "net_total"
    }
}

//Payment Status
struct PaymentStatusModel:Codable {
    let status: Int
    let message: String
}
