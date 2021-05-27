//
//  AvailableStoreModel.swift
//  MyFishingBoat
//
//  Created by vikas on 12/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct AvailableStoreModel: Codable {
    let status: Bool
    let message: String
    let data: [DataAvai]
}

// MARK: - Datum
struct DataAvai: Codable {
    let id, storeName, address, pincode: String?
    let landmark, lat, lng, email: String?
    let phone, status, distance: String?

    enum CodingKeys: String, CodingKey {
        case id
        case storeName = "store_name"
        case address, pincode, landmark, lat, lng, email, phone, status, distance
    }
}
