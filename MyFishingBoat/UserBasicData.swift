//
//  UserBasicData.swift
//  MyFishingBoat
//
//  Created by vikas on 28/10/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
import UIKit

class StoreDetailsData {
    
    static let shared = StoreDetailsData()
    
    var storeID = String()
    var storeName = String()
    var storeAddress = String()
    var km = String()
    var phoneNumber = String()
    var userlat = String()
    var userlong = String()
    var storelat = String()
    var storelong = String()
}

class AddrDetailsData {
    
    static let shared = AddrDetailsData()
    
    var addrID = String()
    var userAddress = String()
    var userlat = String()
    var userlong = String()
    
}

class CuttingType {
    
    static let shared = CuttingType()
    
    var pref1 = String()
    var pref2 = String()
    var pref3 = String()
    
}
