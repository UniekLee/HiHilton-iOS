//
//  SingleArticleModel.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/20.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Alamofire
import RealmSwift

class SingleArticleModel {
    typealias SingleArticleClosure = (Article?, Error?) -> Void
    
    static func getArticle(with articleId: Int, completion: @escaping SingleArticleClosure) {
        let articleRoute = ArticlesRouter.getArticle(articleId: articleId)
        Alamofire.request(articleRoute).validate().responseData { (response) in
            switch response.result {
            case .success(let data):
                SingleArticleModel.decodeArticle(data: data, completion: completion)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
    
    private static func decodeArticle(data: Data, completion: @escaping SingleArticleClosure) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithoutTimeZones)
        do {
            let article = try decoder.decode(Article.self, from: data)
            let realm = try Realm()
            try realm.write {
                realm.add(article, update: true)
            }
            completion(article, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}

