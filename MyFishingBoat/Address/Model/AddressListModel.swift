//
//  AddressListModel.swift
//  MyFishingBoat
//
//  Created by vikas on 22/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct AddressListModel:Codable {
    let status: Int
    let message: String
    let data: [DataAddr]?
}

// MARK: - Datum
struct DataAddr: Codable {
    let id, uid, addressType, address: String?
    let street, flotNo, landMark, pincode: String?
    let ltd, lng, cd: String?
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case addressType = "address_type"
        case address, street
        case flotNo = "flot_no"
        case landMark = "land_mark"
        case pincode, ltd, lng, cd
    }
}



//New address add
struct NewAddrModel:Codable {
    let status: Int
    let message: String
}


//Address delete
struct DeleteAddrModel:Codable {
    let status: Int
    let message: String
}


//Delivery availability (Delivery summary)
struct DeliveryAvailabilityAddr: Codable {
    let status: Bool
    let message: String
    let data: Int?
}
