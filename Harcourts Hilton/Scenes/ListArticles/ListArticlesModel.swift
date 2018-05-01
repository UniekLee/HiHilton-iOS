//
//  ListArticlesController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class ListArticlesModel {
    let realm: Realm
    var articles: Results<Article>
    
    // Tracking last data retrieval
    let lastDataRetrievalKey = "dateOfLastDataRetrievalArticles"
    lazy var _lastDataRetrieval: Date = {
        if let lastRetrieval = UserDefaults.standard.object(forKey: lastDataRetrievalKey) as? Date {
            return lastRetrieval
        }
        return Date()
    }()
    var lastDataRetrieval: Date {
        get {
            return _lastDataRetrieval
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastDataRetrievalKey)
            _lastDataRetrieval = newValue
        }
    }
    
    init() {
        realm = try! Realm()
        articles = realm.objects(Article.self)
    }
    
    func getArticles(completion: @escaping ([Article], Error?) -> Void) {
        if (articles.count == 0 || lastDataRetrieval.timeIntervalSinceNow < -3600) {
            updateArticles(completion: completion)
        } else {
            completion(Array(articles), nil)
        }
    }
    
    func updateArticles(completion: @escaping ([Article], Error?) -> Void) {
        Alamofire.request(ArticlesRouter.readArticles).validate().responseData { [weak self] (response) in
            self?.lastDataRetrieval = Date()
            switch response.result {
            case .success(let data):
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                do {
                    let articles = try decoder.decode([Article].self, from: data)
                    try self?.realm.write {
                        self?.realm.add(articles, update: true)
                    }
                    guard let strongSelf = self else { return }
                    completion(Array(strongSelf.articles), nil)
                } catch let error {
                    guard let strongSelf = self else { return }
                    completion(Array(strongSelf.articles), error)
                }
            case .failure(let error):
                guard let strongSelf = self else { return }
                completion(Array(strongSelf.articles), error)
            }
        }
    }
}
