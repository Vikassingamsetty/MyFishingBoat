//
//  CouponsModel.swift
//  MyFishingBoat
//
//  Created by vikas on 11/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
//CouponList
struct CouponsModel: Codable {
    let status: Int
    let message: String
    let data: [DataCoupon]?
}

// MARK: - Datum
struct DataCoupon: Codable {
    let id, coupID, coupName, coupCode: String?
    let discount, coupPercen, minDisAmount, maxDisAmount: String?
    let minBillAmount, maxBillAmount, startDate, expDate: String?
    let discription, status: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case coupID = "coup_id"
        case coupName = "coup_name"
        case coupCode = "coup_code"
        case discount
        case coupPercen = "coup_percen"
        case minDisAmount = "min_dis_amount"
        case maxDisAmount = "max_dis_amount"
        case minBillAmount = "min_bill_amount"
        case maxBillAmount = "max_bill_amount"
        case startDate = "start_date"
        case expDate = "exp_date"
        case discription, status
    }
}

//Coupon Validation
struct CouponValidModel: Codable {
    let status: Int
    let message: String
    let data: Int?
}
