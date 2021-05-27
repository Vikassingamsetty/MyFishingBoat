//
//  LoginModel.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 11/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct LoginModel: Codable {
    
    let status: Int
    let message: String
    let data: [DataLogin]?
}

// MARK: - Datum
struct DataLogin: Codable {
    let id, uid, lastName, firstName: String
    let email, mobile: String
    //let phoneCode: JSONNull?
    let password, ip, deviceID, deviceToken: String
    let deviceType, userStatus: String
    //let cd: JSONNull?
    
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
        //case cd
    }
}
