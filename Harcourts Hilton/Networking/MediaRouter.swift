//
//  MediaRouter.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import Alamofire

enum MediaRouter: URLRequestConvertible, NetworkRoutable {
    case getMedia(id: Int)
    
    var method: HTTPMethod {
        switch self {
        case .getMedia:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getMedia(let id):
            return "/media/\(id)"
        }
    }
    
    var queries: [URLQueryItem] {
        switch self {
        case .getMedia:
            return []
        }
    }
    
    var cachePolicy: URLRequest.CachePolicy {
        return .returnCacheDataElseLoad
    }
}

