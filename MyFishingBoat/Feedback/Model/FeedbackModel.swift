//
//  FeedbackModel.swift
//  MyFishingBoat
//
//  Created by vikas on 04/12/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

//Rating of product
struct FeedbackModel: Codable {
    let status:Int
    let message:String
}

//Orders checking for status
struct CheckFeedbackModel: Codable {
    let status: Int
    let message: String
    let orderStatus: String?
    let data: [DataFeed]?

    enum CodingKeys: String, CodingKey {
        case status, message
        case orderStatus = "order_status"
        case data
    }
}

// MARK: - Datum
struct DataFeed: Codable {
    let id, rate, uid, orderID: String
    let status, cd: String

    enum CodingKeys: String, CodingKey {
        case id, rate, uid
        case orderID = "order_id"
        case status, cd
    }
}
