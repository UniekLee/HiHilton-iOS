//
//  InternalArticles.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//
// To parse the JSON, add this file to your project and do:
//
//   let rawArticles = try? newJSONDecoder().decode(RawArticles.self, from: jsonData)

import Foundation

typealias RawArticles = [RawArticle]

struct RawArticle: Codable {
    let id: Int
    let date, dateGmt, modified, modifiedGmt: String
    let status, type: String
    let title, content, excerpt: Content
    let featuredMediaId: Int
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, date
        case dateGmt = "date_gmt"
        case modified
        case modifiedGmt = "modified_gmt"
        case status, type, title, content, excerpt
        case featuredMediaId = "featured_media"
        case links = "_links"
    }
}

struct Content: Codable {
    let rendered: String
    let protected: Bool?
}

struct Links: Codable {
    let featuredmedia: [Media]?
    let attachment: [Media]?
    
    enum CodingKeys: String, CodingKey {
        case featuredmedia = "wp:featuredmedia"
        case attachment = "wp:attachment"
    }
}

struct Media: Codable {
    let embeddable: Bool?
    let href: String?
}
