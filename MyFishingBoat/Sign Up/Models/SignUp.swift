//
//  SignUp.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 17/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct SignUpModel: Codable {
    
    let status: Int
    let message: String
    let date: DataSignUp?
}

// MARK: - DateClass
struct DataSignUp: Codable {
    let firstName, lastName, password, email: String?
    let mobile, deviceType, deviceToken, deviceID: String?
    let ip, uid, userStatus, cd: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case password, email, mobile
        case deviceType = "device_type"
        case deviceToken = "device_token"
        case deviceID = "device_id"
        case ip, uid
        case userStatus = "user_status"
        case cd
    }
}
