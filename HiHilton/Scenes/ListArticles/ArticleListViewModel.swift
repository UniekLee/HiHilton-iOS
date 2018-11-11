//
//  ArticleListViewModel.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire

class ArticleListViewModel {
    var articles: [Article] {
        didSet {
            updateFilteredArticles()
        }
    }
    var keyword: String? {
        didSet {
            updateFilteredArticles()
        }
    }
    private var filteredArticles: [Article]
    
    private func updateFilteredArticles() {
        filteredArticles = articles.filter() { article -> Bool in
            guard let safeKeyword = keyword?.lowercased(), !safeKeyword.isEmpty else { return true }
            
            let titleContainsKeyword = (article.title?.lowercased().contains(safeKeyword) == true)
            let contentContainsKeyword = (article.content?.lowercased().contains(safeKeyword) == true)
            
            return titleContainsKeyword || contentContainsKeyword
        }
    }
    
    var numberOfItems: Int {
        return filteredArticles.count
    }
    
    init(with articles: [Article]) {
        self.filteredArticles = []
        self.articles = articles
        updateFilteredArticles()
    }
    
    func article(for item: Int) -> Article {
        return filteredArticles[item]
    }
    
    func fetchImagePaths(for items: [Int]) {
        for item in items {
            fetchImagePath(for: filteredArticles[item])
        }
    }
    
    func imagePath(for article: Article, completion: @escaping (_ imagePath: String?) -> Void) {
        fetchImagePath(for: article, completion: completion)
    }
}

extension ArticleListViewModel {
    public func filterArticles(using keyword: String) {
        self.keyword = keyword
    }
}

// Image prefetching
extension ArticleListViewModel {
    private func fetchImagePath(for article: Article, completion: ((_ thumbnailPath: String?) -> Void)? = nil) {
        guard
            let imageId = article.featuredImage?.id,
            imageId != 0,
            article.featuredImage?.path == nil || article.featuredImage?.path?.isEmpty == true
            else {
                completion?(article.featuredImage?.path)
                return
        }
        let media = MediaRouter.getMedia(id: imageId)
        Alamofire.request(media).validate().responseData { [weak self, article] (response) in
            switch response.result {
            case .success(let data):
                ArticleListViewModel.decodeMedia(data: data, completion: { (decodedMedia) in
                    guard let media = decodedMedia else { return }
                    let thumbnailPath = media.thumbnailPath
                    self?.setThumbnail(path: thumbnailPath, for: article)
                    completion?(thumbnailPath)
                })
            case .failure(let error):
                debugPrint(error.localizedDescription)
                completion?(nil)
            }
        }
    }
    
    private func setThumbnail(path: String, for article: Article) -> ()? {
        return try? Realm().write {
            article.featuredImage?.path = path
        }
    }
    
    private static func decodeMedia(data: Data, completion: @escaping (Media?) -> Void) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        do {
            let media = try decoder.decode(Media.self, from: data)
            completion(media)
        } catch let decodeError {
            debugPrint(decodeError.localizedDescription)
            completion(nil)
        }
    }
}
