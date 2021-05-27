//
//  ProfileDetails.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 10/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct CustomerDetailsID: Codable {
    
    let id: Int
    let dateCreated, dateCreatedGmt, dateModified, dateModifiedGmt: String
    let email, firstName, lastName, role: String
    let username: String
    let billing, shipping: Ing
    let isPayingCustomer: Bool
    let avatarURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateCreated = "date_created"
        case dateCreatedGmt = "date_created_gmt"
        case dateModified = "date_modified"
        case dateModifiedGmt = "date_modified_gmt"
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case role, username, billing, shipping
        case isPayingCustomer = "is_paying_customer"
        case avatarURL = "avatar_url"
        
    }
}

// MARK: - Ing
struct Ing: Codable {
    let firstName, lastName, company, address1: String
    let address2, city, postcode, country: String
    let state: String
    let email, phone: String?
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case company
        case address1 = "address_1"
        case address2 = "address_2"
        case city, postcode, country, state, email, phone
    }
}
