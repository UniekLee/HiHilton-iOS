//
//  ArticlesRouter.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire

enum ArticlesRouter: URLRequestConvertible, NetworkRoutable {
    case listArticles
    case getMedia(articleId: Int)
    
    var method: HTTPMethod {
        switch self {
        case .listArticles, .getMedia:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .listArticles:
            return "/articles"
        case .getMedia:
            return "/media"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .listArticles:
            return []
        case .getMedia(let articleId):
            return [
                URLQueryItem(name: "parent", value: "\(articleId)")
            ]
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .useProtocolCachePolicy
    }
}
