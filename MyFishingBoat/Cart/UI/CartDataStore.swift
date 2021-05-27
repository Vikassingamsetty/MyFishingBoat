//
//  CartDataStore.swift
//  MyFishingBoat
//
//  Created by vikas on 13/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

class CartDataStore {
    
    static let shared = CartDataStore()
    
    var deliverType = String()
    var SlotsSelectedCell = String()
    var deliveryDate = String()
    var total = String()
    var deliveryCharges = String()
    var gst = String()
    var netTotal = String()
    var couponAmount = String()
    
}
