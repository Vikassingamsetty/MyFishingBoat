//
//  GetcartItermsModel.swift
//  MyFishingBoat
//
//  Created by Appcare on 22/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct CartDetailsWithProductsKey: Codable {
    
    let key: String
    let productID, variationID: Int
    let quantity: Int
    let dataHash: String
    let lineSubtotal, lineSubtotalTax, lineTotal, lineTax: Int
    let productName, productTitle, productPrice: String
    let productImage: String
    
    enum CodingKeys: String, CodingKey {
        case key
        case productID = "product_id"
        case variationID = "variation_id"
        case quantity
        case dataHash = "data_hash"
        case lineSubtotal = "line_subtotal"
        case lineSubtotalTax = "line_subtotal_tax"
        case lineTotal = "line_total"
        case lineTax = "line_tax"
        case productName = "product_name"
        case productTitle = "product_title"
        case productPrice = "product_price"
        case productImage = "product_image"
    }
}


