//
//  TimeSlotsModel.swift
//  MyFishingBoat
//
//  Created by vikas on 09/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct TimeSlotsModel:Codable {
    let status: Bool
    let message: String
    let data: [DataSlots]?
}

// MARK: - Datum
struct DataSlots: Codable {
    let slots, status: String?
}
