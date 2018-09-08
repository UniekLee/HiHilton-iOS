//
//  ArticlesRouter.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire

enum ArticlesRouter: URLRequestConvertible {
    case listArticles
    case getMedia(articleId: Int)
    
    static let baseURLString = "http://localhost:8888/hilton"
    static let baseRESTString = "/wp-json/wp/v2"
    
    var method: HTTPMethod {
        switch self {
        case .listArticles, .getMedia: return .get
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
    
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: ArticlesRouter.baseURLString) else {
            let baseURL = try ArticlesRouter.baseURLString.asURL()
            return URLRequest(url: baseURL)
        }
        urlComponents.path = urlComponents.path
            .appending(ArticlesRouter.baseRESTString)
            .appending(path)
        urlComponents.queryItems = queries
        
        let url = try urlComponents.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
