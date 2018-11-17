//
//  TTTAttributedLabelExtensions.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import TTTAttributedLabel

extension TTTAttributedLabel {
    var htmlText: String? {
        set {
            guard let attributedString = newValue?.attributedStringFromHTML else { return }
            setHTML(text: attributedString,
                    withAttributes: [
                        NSAttributedString.Key.font : Font.forStyle(Style.SingleArticle.content)
                ]
            )
        }
        get {
            return attributedText.htmlString
        }
    }
    
    func setHTML(text: NSMutableAttributedString, withAttributes attributes: [NSAttributedString.Key : Any]) {
        text.addAttributes(attributes, range: text.wholeString)
        setText(text)
        adjustsFontForContentSizeCategory = true
    }
    
    func setHTML(text: String?, withAttributes attributes: [NSAttributedString.Key : Any]) {
        guard let attributedString = text?.attributedStringFromHTML else { return }
        attributedString.addAttributes(attributes, range: attributedString.wholeString)
        setText(attributedString)
        adjustsFontForContentSizeCategory = true
    }
}
