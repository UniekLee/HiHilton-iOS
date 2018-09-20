//
//  RawMedia.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let rawMedias = try? newJSONDecoder().decode(RawMedias.self, from: jsonData)

import Foundation

typealias RawMedias = [RawMedia]

struct RawMedia: Codable {
    let id: Int
    let dateGmt, modifiedGmt: String
    let title, caption: Content
    let mediaType, mimeType: String?
    let mediaDetails: MediaDetails
    let post: Int?
    let sourceURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case dateGmt = "date_gmt"
        case modifiedGmt = "modified_gmt"
        case title, caption
        case mediaType = "media_type"
        case mimeType = "mime_type"
        case mediaDetails = "media_details"
        case post
        case sourceURL = "source_url"
    }
}

struct MediaDetails: Codable {
    let width, height: Int
    let file: String
    let sizes: Sizes
}

struct Sizes: Codable {
    let thumbnail, medium, large, full: ImageSizeDetails?
}

struct ImageSizeDetails: Codable {
    let file: String
    let width, height: Int
    let mimeType, sourceURL: String
    
    enum CodingKeys: String, CodingKey {
        case file, width, height
        case mimeType = "mime_type"
        case sourceURL = "source_url"
    }
}
