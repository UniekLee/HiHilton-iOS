//
//  StringExtensions.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

extension String {
    var attributedStringFromHTML: NSMutableAttributedString {
        guard let data = data(using: .utf8) else { return NSMutableAttributedString() }
        do {
            return try NSMutableAttributedString(data: data,
                                                 options: [.documentType: NSAttributedString.DocumentType.html,
                                                           .characterEncoding : String.Encoding.utf8.rawValue],
                                                 documentAttributes: nil)
        } catch {
            return NSMutableAttributedString()
        }
    }
    
//    func asURL() -> URL? {
//        return URL(string: self)
//    }
}
