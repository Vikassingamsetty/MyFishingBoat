//
//  ListAllProductCategories.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 07/08/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

// MARK: - List All product categories (GET)
struct CategoryListAllProducts: Codable {
    let status: Int
    let message: String
    let data: [DataCategory]?
}

// MARK: - Datum
struct DataCategory: Codable {
    let id, name: String?
    let photo, imageIos: String?
    let imageAnd: String?
    let status, cd: String?

    enum CodingKeys: String, CodingKey {
        case id, name, photo
        case imageIos = "image_ios"
        case imageAnd = "image_and"
        case status, cd
    }
}


//MARK:- Auto Scroll Images Home screen
struct AutoImgScrollModel: Codable {
    let status: Int
    let message: String
    let data: [DataImgScroll]?
}

// MARK: - Datum
struct DataImgScroll: Codable {
    let id, name: String?
    let image, imageIos: String?
    let imageAnd: String?
    let cd: String?

    enum CodingKeys: String, CodingKey {
        case id, name, image
        case imageIos = "image_ios"
        case imageAnd = "image_and"
        case cd
    }
}



//MARK:- Static categories list
struct CategoryStaticList: Codable {
    let status: Int
    let message: String
    let data: [DataStatic]?
}

//Datum
struct DataStatic: Codable {
    let id, catID, name, photo: String?
    let status, cd: String?
    let fixedCategoryAndroid, fixedCategoryIos, fixedCategoryWeb: String?

    enum CodingKeys: String, CodingKey {
        case id
        case catID = "cat_id"
        case name, photo, status, cd
        case fixedCategoryAndroid = "fixed_category_android"
        case fixedCategoryIos = "fixed_category_ios"
        case fixedCategoryWeb = "fixed_category_web"
    }
}
