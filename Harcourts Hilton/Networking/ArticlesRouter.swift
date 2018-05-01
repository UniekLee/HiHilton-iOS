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
    case readArticles
    
    static let baseURLString = "http://localhost:8888/hilton"
    static let baseRESTString = "wp-json/swiftypress/v2"
    
    var method: HTTPMethod {
        switch self {
        case .readArticles: return .get
        }
    }
    
    var path: String {
        switch self {
        case .readArticles:
            return "/articles"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try ArticlesRouter.baseURLString.asURL()
        var urlRequest = URLRequest(url: url
            .appendingPathComponent(ArticlesRouter.baseRESTString)
            .appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        
        return urlRequest
    }
}
