//
//  AboutUsModel.swift
//  MyFishingBoat
//
//  Created by vikas on 12/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
//about us
struct AboutUsModel: Codable {
    let status: Int
    let message: String
    let data: [DataAbout]
}

// MARK: - Datum
struct DataAbout: Codable {
    let id, discription, cd: String?
}

//T&C
struct TCModel: Codable {
    let status: Int
    let message: String
    let data: [DataTC]
}

// MARK: - Datum
struct DataTC: Codable {
    let id, discription, cd: String?
}

//privacyPolicies
struct PrivacyModel: Codable {
    let status: Int
    let message: String
    let data: [DataPrivacy]
}

// MARK: - Datum
struct DataPrivacy: Codable {
    let id, discription, cd: String?
}

//ContactUS
struct ContactUsModel: Codable {
    let status: Int
    let message: String
}

//FAQ's
struct FAQModel: Codable {
    let status: Int
    let message: String
    let data: [DataFaq]
}

// MARK: - Datum
struct DataFaq: Codable {
    let id, question, discription, cd: String?
}
