//
//  AddToWishlist.swift
//  MyFishingBoat
//
//  Created by vikas on 28/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
//Add to wishlist
struct AddToWishlist: Codable {
    let status: Int
    let message: String
    let data: DataAddWish
}

// MARK: - DataClass
struct DataAddWish: Codable {
    let uid, productID, cid: String

    enum CodingKeys: String, CodingKey {
        case uid
        case productID = "product_id"
        case cid
    }
}

//2nd in cart addto wishlist
struct AddWishlist: Codable {
    let status: Int
    let message: String
    let data: DataAdWish
}

// MARK: - DataClass
struct DataAdWish: Codable {
    let uid, productID, cid: String

    enum CodingKeys: String, CodingKey {
        case uid
        case productID = "product_id"
        case cid
    }
}

//delete from wishlist
struct RemoveWishlist:Codable {
    let status: Int
    let message: String
}
