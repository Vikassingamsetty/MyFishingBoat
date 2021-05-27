//
//  MobileOTP.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 03/09/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct MobileOTPModel: Codable {
    let status: Int
    let message: String
    let data: [DataOTP]?
}

// MARK: - Datum
struct DataOTP: Codable {
    let id, uid, lastName, firstName: String
    let email, mobile: String
    //let phoneCode: JSONNull?
    let password, ip, deviceID, deviceToken: String
    let deviceType, userStatus, cd: String
    
    enum CodingKeys: String, CodingKey {
        case id, uid
        case lastName = "last_name"
        case firstName = "first_name"
        case email, mobile
        //case phoneCode = "phone_code"
        case password, ip
        case deviceID = "device_id"
        case deviceToken = "device_token"
        case deviceType = "device_type"
        case userStatus = "user_status"
        case cd
    }
}

