//
//  ListArticlesViewModel.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift

protocol ListArticlesViewModelProtocol {
    func reloadArticlesSucceeded()
    func reloadArticlesFailed(with error: Error)
}

class ListArticlesViewModel {
    let model: ListArticlesModel
    var delegate: ListArticlesViewModelProtocol?
    var articles: [Article] = []
    var numberOfItems: Int {
        return articles.count
    }
    
    init() {
        self.model = ListArticlesModel()
        model.getArticles(completion: handleDataFetch(with:error:))
    }
    
    func reload() {
        model.updateArticles(completion: handleDataFetch(with:error:))
    }
    
    func handleDataFetch(with newArticles: [Article], error: Error?) {
        if let error = error {
            delegate?.reloadArticlesFailed(with: error)
            return
        }
        
        articles = newArticles
        delegate?.reloadArticlesSucceeded()
    }
    
    func title(for item: Int) -> String {
        return articles[item].title
    }
}
