//
//  AttributedStringExtensions.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

extension NSAttributedString {
    var htmlString: String {
        let documentAttributes: [NSAttributedString.DocumentAttributeKey: Any] = [.documentType: NSAttributedString.DocumentType.html, .characterEncoding : String.Encoding.utf8]
        do {
            let htmlData = try data(from: NSRange(location: 0, length: length), documentAttributes: documentAttributes)
            return String(data: htmlData, encoding: .utf8) ?? String()
        } catch {
            return String()
        }
    }
    
    var wholeString: NSRange {
        return NSRange(location: 0, length: length)
    }
}
