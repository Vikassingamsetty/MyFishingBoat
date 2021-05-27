//
//  OrderConfirmationModel.swift
//  MyFishingBoat
//
//  Created by vikas on 17/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct OrderConfirmationModel: Codable {
    let status: Int
    let message: String
    let data: [DataOrder]
}

// MARK: - Datum
struct DataOrder: Codable {
    let paymentStatus, orderID, userID, storeID: String?
    let storename, storeaddress, storePincode, stroreLandmark: String?
    let storeLat, storeLng, storeEmail, storePhone: String?
    let userAdreesID, userAddressType, userAddress, userStreet: String?
    let userFlotno, userLandMark, userPincode, userLat: String?
    let userLng, discount, total, deliveryCharge: String?
    let gst: String?

    enum CodingKeys: String, CodingKey {
        case paymentStatus = "payment_status"
        case orderID
        case userID = "UserID"
        case storeID = "store_id"
        case storename, storeaddress
        case storePincode = "store_pincode"
        case stroreLandmark = "strore_landmark"
        case storeLat = "store_lat"
        case storeLng = "store_lng"
        case storeEmail = "store_email"
        case storePhone = "store_phone"
        case userAdreesID = "userAdreesId"
        case userAddressType = "user_address_type"
        case userAddress = "user_address"
        case userStreet = "user_street"
        case userFlotno = "user_flotno"
        case userLandMark = "user_land_mark"
        case userPincode = "user_pincode"
        case userLat = "user_lat"
        case userLng = "user_lng"
        case discount, total
        case deliveryCharge = "delivery_charge"
        case gst
    }
}
