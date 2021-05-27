//
//  DeliveryAddrModel.swift
//  MyFishingBoat
//
//  Created by Vikas on 30/12/20.
//

import Foundation

struct DeliveryAddrModel: Codable {
    let status: Int
    let message: String
    let data: [DataAddrs]?
}

// MARK: - Datum
struct DataAddrs: Codable {
    let id, areaName, latitude, langitude: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case id
        case areaName = "area_name"
        case latitude, langitude, status
    }
}
