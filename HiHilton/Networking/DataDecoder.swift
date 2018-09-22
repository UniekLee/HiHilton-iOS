//
//  DataDecoder.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/22.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation

class DataDecoder {
    static let shared: DataDecoder = DataDecoder()
    private let decoder: JSONDecoder
    
    init() {
        decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.iso8601WithoutTimeZones)
    }
    
    func decode<T: Decodable>(data: Data, toType type: T.Type, completion: @escaping (T?, Error?) -> Void) {
        do {
            let decoded = try decoder.decode(type, from: data)
            completion(decoded, nil)
        } catch let error {
            completion(nil, error)
        }
    }
}
