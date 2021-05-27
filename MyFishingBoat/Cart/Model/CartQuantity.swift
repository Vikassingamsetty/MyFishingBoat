//
//  CartQuantity.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 31/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

//Cart quantity Model
struct CartQuantityValue: Codable {
    
    let message: String
    let quantity: Int
    
}


//Time slots for model
struct TimeSlotsCart: Codable {
    let id: String
    let text: String
}
