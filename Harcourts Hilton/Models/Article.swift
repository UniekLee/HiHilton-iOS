//
//  Article.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var title = ""
    @objc dynamic var excerpt: String? = ""
    @objc dynamic var content = ""
    
    @objc dynamic var date = ""
    @objc dynamic var modified = ""
    @objc dynamic var featuredImage: Image?
    let categories = List<Category>()
    let tags = List<Tag>()
    let images = List<Image>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case excerpt
        case content
        case date
        case modified
        case featuredImage = "featured_media"
        case categories
        case tags
        case images
        
    }
    
    required convenience init(from decoder: Decoder) throws {
        let rawArticle = try RawArticle(from: decoder)
        self.init()
        id = rawArticle.id
        title = rawArticle.title.rendered
        content = rawArticle.content.rendered
        excerpt = rawArticle.excerpt.rendered
        date = rawArticle.dateGmt
        modified = rawArticle.modifiedGmt
        featuredImage = Image()
        featuredImage?.id = rawArticle.featuredMediaId
        featuredImage?.link = rawArticle.links?.featuredmedia?.first?.href
//
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        id = try container.decode(Int.self, forKey: .id)
//        title = try container.decode(String.self, forKey: .title)
//        excerpt = try container.decode(String.self, forKey: .excerpt)
//        content = try container.decode(String.self, forKey: .content)
//        date = try container.decode(Date.self, forKey: .date)
//        modified = try container.decode(Date.self, forKey: .modified)
//        featuredImage = try container.decodeIfPresent(Image.self, forKey: .featuredImage)
//
//        let categoriesArray = try container.decode([Category].self, forKey: .categories)
//        categories.append(objectsIn: categoriesArray)
//
//        let tagsArray = try container.decode([Tag].self, forKey: .tags)
//        tags.append(objectsIn: tagsArray)
//
//        let imageArray = try container.decode([Image].self, forKey: .images)
//        images.append(objectsIn: imageArray)
    }
}

class Author: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var link = ""
    @objc dynamic var avatar = ""
}

class Category: Object, Decodable {
    
}

class Tag: Object, Decodable {
    
}

class Image: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var link: String?
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var thumbnail_link = ""
    @objc dynamic var thumbnail_width = 0
    @objc dynamic var thumbnail_height = 0
}
