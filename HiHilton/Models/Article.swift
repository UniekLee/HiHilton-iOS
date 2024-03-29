//
//  Article.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift

class Article: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var title: String?
    @objc dynamic var excerpt: String?
    @objc dynamic var content: String?
    
    @objc dynamic var date: Date?
    @objc dynamic var modified: Date?
    @objc dynamic var featuredImage: WPImage?
    
    @objc dynamic var fetched: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
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
        featuredImage = WPImage()
        featuredImage?.id = rawArticle.featuredMediaId
        fetched = true
    }
}

class WPImage: Object, Decodable {
    @objc dynamic var id = 0
    @objc dynamic var path: String?
    @objc dynamic var fetched: Bool = false
}
