//
//  ArticleListViewModel.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift

class ArticleListViewModel {
    var articles: [Article]
    
    var numberOfItems: Int {
        return articles.count
    }
    
    init(with articles: [Article]) {
        self.articles = articles
    }
    
    func title(for item: Int) -> String {
        return articles[item].title
    }
    
    func article(for item: Int) -> Article {
        return articles[item]
    }
}
