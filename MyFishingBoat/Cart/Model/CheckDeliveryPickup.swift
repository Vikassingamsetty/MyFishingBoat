//
//  CheckDeliveryPickup.swift
//  MyFishingBoat
//
//  Created by Vikas on 28/12/20.
//

import Foundation

//Delivery Summary
struct CheckDeliverySummaryModel: Codable {
    let status: Bool
    let message: String
    let data: [DataDP]?
}

// MARK: - Datum
struct DataDP: Codable {
    let id, uid, addressType, address: String?
    let street, flotNo, landMark, pincode: String?
    let ltd, lng, cd, status: String?
    let distance: String?

    enum CodingKeys: String, CodingKey {
        case id, uid
        case addressType = "address_type"
        case address, street
        case flotNo = "flot_no"
        case landMark = "land_mark"
        case pincode, ltd, lng, cd, status, distance
    }
}

//PickUp Summary
struct CheckPickupSummaryModel: Codable {
    let status: Bool
    let message: String
    let data: [DataPD]?
}

// MARK: - Datum
struct DataPD: Codable {
    let id, storeName, address, pincode: String?
    let landmark, lat, lng, email: String?
    let phone, status, distance: String?

    enum CodingKeys: String, CodingKey {
        case id
        case storeName = "store_name"
        case address, pincode, landmark, lat, lng, email, phone, status, distance
    }
}
