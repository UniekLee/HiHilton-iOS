//
//  TTTAttributedLabelExtensions.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import TTTAttributedLabel

extension TTTAttributedLabel {
    var htmlText: String? {
        set {
            guard let attributedString = newValue?.attributedStringFromHTML else { return }
            attributedString.addAttributes([NSAttributedStringKey.font : UIFont.systemFont(ofSize: 20, weight: .light)], range: attributedString.wholeString)
            attributedText = attributedString
        }
        get {
            return attributedText.htmlString
        }
    }
    
    func setHTML(text: String, withAttributes attributes: [NSAttributedStringKey : Any]) {
        
    }
}
