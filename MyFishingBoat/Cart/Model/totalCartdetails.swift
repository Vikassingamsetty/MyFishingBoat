//
//  totalCartdetails.swift
//  MyFishingBoat
//
//  Created by Appcare on 22/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

struct CartDetails : Codable {

  let subtotal: String?
     let subtotalTax: Int?
     let shippingTotal: String?
     let shippingTax: Int?
  //   let shippingTaxes: [JSONAny]
     let discountTotal, discountTax: Int?
     let cartContentsTotal: String?
     let cartContentsTax: Int?
  //   let cartContentsTaxes: [JSONAny]
     let feeTotal: String?
     let feeTax: Int?
  //   let feeTaxes: [JSONAny]
     let total: String?
     let totalTax: Int?

     enum CodingKeys: String, CodingKey {
         case subtotal
         case subtotalTax = "subtotal_tax"
         case shippingTotal = "shipping_total"
         case shippingTax = "shipping_tax"
       //  case shippingTaxes = "shipping_taxes"
         case discountTotal = "discount_total"
         case discountTax = "discount_tax"
         case cartContentsTotal = "cart_contents_total"
         case cartContentsTax = "cart_contents_tax"
    //     case cartContentsTaxes = "cart_contents_taxes"
         case feeTotal = "fee_total"
         case feeTax = "fee_tax"
       //  case feeTaxes = "fee_taxes"
         case total
         case totalTax = "total_tax"
     }
 }

 
