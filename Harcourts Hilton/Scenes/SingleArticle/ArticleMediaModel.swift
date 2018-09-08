//
//  ArticleMediaModel.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class ArticleMediaModel {
    
    static func getMedia(for articleId: Int, completion: @escaping ([Media], Error?) -> Void) {
        Alamofire.request(ArticlesRouter.getMedia(articleId: articleId)).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                ArticleMediaModel.decodeMedia(data: data, completion: completion)
            case .failure(let error):
                completion([], error)
            }
        }
    }
    
    private static func decodeMedia(data: Data, completion: @escaping ([Media], Error?) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let media = try decoder.decode([Media].self, from: data)
            completion(Array(media), nil)
        } catch let error {
            completion([], error)
        }
    }
}
