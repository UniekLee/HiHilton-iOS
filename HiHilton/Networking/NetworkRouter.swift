//
//  BaseRouter.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire

struct NetworkRouter {
    #if DEBUG
    static let scheme = "http"
    static let host = "localhost:8888/hilton"
    #else
    static let scheme = "https"
    static let host = "hihilton.com"
    #endif

    static var baseURLString: String {
        return "\(NetworkRouter.scheme)://\(NetworkRouter.host)"
    }
    static let baseRESTString = "/wp-json/wp/v2"
}

protocol NetworkRoutable {
    var method: HTTPMethod { get }
    var path: String { get }
    var queries: [URLQueryItem] { get }
    var cachePolicy: URLRequest.CachePolicy { get }
}

extension URLRequestConvertible where Self: NetworkRoutable {
    func asURLRequest() throws -> URLRequest {
        guard var urlComponents = URLComponents(string: NetworkRouter.baseURLString) else {
            let baseURL = try NetworkRouter.baseURLString.asURL()
            return URLRequest(url: baseURL)
        }
        urlComponents.path = urlComponents.path
            .appending(NetworkRouter.baseRESTString)
            .appending(path)
        urlComponents.queryItems = queries
        
        let url = try urlComponents.asURL()
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.cachePolicy = cachePolicy
        
        return urlRequest
    }
}
