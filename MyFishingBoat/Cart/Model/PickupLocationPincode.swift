//
//  PickupLocationPincode.swift
//  MyFishingBoat
//
//  Created by Appcare Apple on 05/09/20.
//  Copyright © 2020 Anil. All rights reserved.
//

import Foundation

//Error
//Pickup location not available user PINCODE
struct PickupError: Codable {
    let success: Bool
    let message: String
}

//Success
//Pickup location available at PINCODE
struct PickupLocationPincode: Codable {
    let success: Bool
        let data: [Datum]
        let zoneID: Int

        enum CodingKeys: String, CodingKey {
            case success, data
            case zoneID = "zone_id"
        }
    }

    // MARK: - Datum
    struct Datum: Codable {
        let id: Int
        let postAuthor, postDate, postDateGmt, postContent: String
        let postTitle, postExcerpt, postStatus, commentStatus: String
        let pingStatus, postPassword, postName, toPing: String
        let pinged, postModified, postModifiedGmt, postContentFiltered: String
        let postParent: Int
        let guid: String
        let menuOrder: Int
        let postType, postMIMEType, commentCount, filter: String
        let location: String

        enum CodingKeys: String, CodingKey {
            case id = "ID"
            case postAuthor = "post_author"
            case postDate = "post_date"
            case postDateGmt = "post_date_gmt"
            case postContent = "post_content"
            case postTitle = "post_title"
            case postExcerpt = "post_excerpt"
            case postStatus = "post_status"
            case commentStatus = "comment_status"
            case pingStatus = "ping_status"
            case postPassword = "post_password"
            case postName = "post_name"
            case toPing = "to_ping"
            case pinged
            case postModified = "post_modified"
            case postModifiedGmt = "post_modified_gmt"
            case postContentFiltered = "post_content_filtered"
            case postParent = "post_parent"
            case guid
            case menuOrder = "menu_order"
            case postType = "post_type"
            case postMIMEType = "post_mime_type"
            case commentCount = "comment_count"
            case filter, location
        }
    }
