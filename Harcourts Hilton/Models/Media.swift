//
//  Media.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift

class Media: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var title: String = ""
    @objc dynamic var caption: String = ""
    @objc dynamic var date: String = ""
    @objc dynamic var modified: String = ""
    @objc dynamic var type: String? = ""
    @objc dynamic var fullPath: String = ""
    @objc dynamic var thumbnailPath: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    required convenience init(from decoder: Decoder) throws {
        let rawMedia = try RawMedia(from: decoder)
        self.init()
        id = rawMedia.id
        title = rawMedia.title.rendered
        caption = rawMedia.caption.rendered
        date = rawMedia.dateGmt
        modified = rawMedia.modifiedGmt
        type = rawMedia.mediaType
        fullPath = rawMedia.mediaDetails.sizes.full?.sourceURL ?? ""
        thumbnailPath = rawMedia.mediaDetails.sizes.thumbnail?.sourceURL ?? ""
    }
}
