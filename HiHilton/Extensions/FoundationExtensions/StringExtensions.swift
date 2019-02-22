//
//  StringExtensions.swift
//  HiHilton
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
}

extension String {
    var htmlStringFormatted: NSAttributedString? {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            let content = try NSMutableAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
            let wholeContent = NSRange(location: 0, length: content.length)
            let fontFamily = Font.forStyle(Style.SingleArticle.content).familyName
            let fontPointSize = Font.forStyle(Style.SingleArticle.content).pointSize
            let htmlPointSize = (content.attributes(at: 0, effectiveRange: nil)[.font] as? UIFont)?.pointSize ?? 1
            let fontSizeMultiplier = fontPointSize / htmlPointSize
            
            content.enumerateAttribute(.font, in: wholeContent, options: .longestEffectiveRangeNotRequired) { attrib, range, _ in
                if let htmlFont = attrib as? UIFont {
                    let traits = htmlFont.fontDescriptor.symbolicTraits
                    var descrip = htmlFont.fontDescriptor.withFamily(fontFamily)
                    if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitBold.rawValue) != 0 {
                        descrip = descrip.withSymbolicTraits(.traitBold)!
                    } else {
                        descrip = descrip.withFace("Light")
                    }
                    
                    if (traits.rawValue & UIFontDescriptor.SymbolicTraits.traitItalic.rawValue) != 0 {
                        descrip = descrip.withSymbolicTraits(.traitItalic)!
                    }
                    content.addAttribute(.font, value: UIFont(descriptor: descrip, size: htmlFont.pointSize * fontSizeMultiplier), range: range)
                }
            }
            
            print("Font size multipier: \(fontSizeMultiplier)")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.paragraphSpacing = 15 * fontSizeMultiplier
            content.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: wholeContent)
            
            return content
        } catch {
            return NSAttributedString()
        }
    }
}
