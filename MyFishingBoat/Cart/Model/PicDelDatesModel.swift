//
//  PicDelDatesModel.swift
//  MyFishingBoat
//
//  Created by vikas on 10/11/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation
struct PicDelDates: Codable {
    let status: Bool
    let message: String
    let data: [Datapic]?
}

// MARK: - Datum
struct Datapic: Codable {
    let scalar: String?
}
