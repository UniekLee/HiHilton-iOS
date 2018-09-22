//
//  ArticleMediaModel.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Alamofire
import RealmSwift

class ArticleMediaModel {
    
    static func getMedia(for articleId: Int, completion: @escaping ([Media], Error?) -> Void) {
        Alamofire.request(ArticlesRouter.getMedia(articleId: articleId)).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                DataDecoder.shared.decode(data: data, toType: [Media].self, completion: { (media, error) in
                    if let media = media {
                        completion(Array(media),  error)
                    } else {
                        completion([], error)
                    }
                })
            case .failure(let error):
                completion([], error)
            }
        }
    }
}
