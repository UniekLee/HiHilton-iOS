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
    @objc dynamic var link: String? = ""
    
    @objc dynamic var date = Date()
    @objc dynamic var modified = Date()
    @objc dynamic var author: Author?
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
        case link
        case date
        case modified
        case author
        case featuredImage = "featured_media"
        case categories
        case tags
        case images
        
    }
    
    required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        excerpt = try container.decode(String.self, forKey: .excerpt)
        content = try container.decode(String.self, forKey: .content)
        link = try container.decode(String.self, forKey: .link)
        date = try container.decode(Date.self, forKey: .date)
        modified = try container.decode(Date.self, forKey: .modified)
        author = try container.decode(Author.self, forKey: .author)
        featuredImage = try container.decode(Image.self, forKey: .featuredImage)
        
        let categoriesArray = try container.decode([Category].self, forKey: .categories)
        categories.append(objectsIn: categoriesArray)
        
        let tagsArray = try container.decode([Tag].self, forKey: .tags)
        tags.append(objectsIn: tagsArray)
        
        let imageArray = try container.decode([Image].self, forKey: .images)
        images.append(objectsIn: imageArray)
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
    @objc dynamic var link = ""
    @objc dynamic var width = 0
    @objc dynamic var height = 0
    @objc dynamic var thumbnail_link = ""
    @objc dynamic var thumbnail_width = 0
    @objc dynamic var thumbnail_height = 0
}
