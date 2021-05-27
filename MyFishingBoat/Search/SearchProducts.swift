//
//  SearchProducts.swift
//  MyFishingBoat
//
//  Created by Appcare on 20/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct SearchProductsModel: Codable {
    let status: Int
    let message: String
    let data: [DataSearch]?
}

// MARK: - Datum
struct DataSearch: Codable {
  let id, productName, productPrice, priceDescription: String?
  let quantityDescription, productWeight, productQty, productStatus: String?
  let stockStatus: String?
  let productPhotos, imageIos: String?
  let imageAnd: String?
  let productDiscription, catID, cuttingID, facts: String?
  let healthBenefits, recipes, bestSellar, cd: String?
  let cuttingPreferencesData: [CuttingPrefSearch]?
  let wishlist: String?

  enum CodingKeys: String, CodingKey {
      case id
      case productName = "product_name"
      case productPrice = "product_price"
      case priceDescription = "price_description"
      case quantityDescription = "quantity_description"
      case productWeight = "product_weight"
      case productQty = "product_qty"
      case productStatus = "product_status"
      case stockStatus = "stock_status"
      case productPhotos = "product_photos"
      case imageIos = "image_ios"
      case imageAnd = "image_and"
      case productDiscription = "product_discription"
      case catID = "cat_id"
      case cuttingID = "cutting_id"
      case facts
      case healthBenefits = "health_benefits"
      case recipes
      case bestSellar = "best_sellar"
      case cd
      case cuttingPreferencesData = "cutting_preferences_data"
      case wishlist
  }
}

// MARK: - CuttingPreferencesDatum
struct CuttingPrefSearch: Codable {
  let type, cuttingPreferencesID: String?
  let image: String?
  let imageAnd, imageIos: String?

  enum CodingKeys: String, CodingKey {
      case type
      case cuttingPreferencesID = "cutting_preferences_id"
      case image
      case imageAnd = "image_and"
      case imageIos = "image_ios"
  }
}
