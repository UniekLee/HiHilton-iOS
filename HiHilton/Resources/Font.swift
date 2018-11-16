import UIKit

class Font {
    fileprivate static let provider: Font = Font()
    
    private let fontName = "SourceSansPro"
    fileprivate lazy var scaledFont: ScaledFont = {
        return ScaledFont(fontName: fontName)
    }()
}

extension Font {
    static func forStyle(_ style: UIFont.TextStyle) -> UIFont {
        return Font.provider.scaledFont.font(forTextStyle: style)
    }
}

//extension UIFont.TextStyle {
//    static func style(for useCase: Style) -> UIFont.TextStyle {
//        return useCase
//    }
//}

struct Style {
    struct ArticleList {
        static let header = UIFont.TextStyle.title1
        
        struct Article {
            static let date = UIFont.TextStyle.subheadline
            static let title = UIFont.TextStyle.title3
            static let excerpt = UIFont.TextStyle.callout
        }
    }
    
    struct SingleArticle {
        static let title = UIFont.TextStyle.title1
        static let content = UIFont.TextStyle.body
    }
}

extension UILabel {
    func setTextStyle(as style: UIFont.TextStyle) {
        font = Font.provider.scaledFont.font(forTextStyle: style)
        adjustsFontForContentSizeCategory = true
    }
}

public final class ScaledFont {
    
    private struct FontDescription: Decodable {
        let fontSize: CGFloat
        let fontName: String
    }
    
    private typealias StyleDictionary = [UIFont.TextStyle.RawValue: FontDescription]
    private var styleDictionary: StyleDictionary?
    
    public init(fontName: String) {
        if let url = HiHilton.url(forResource: fontName, withExtension: "plist"),
            let data = try? Data(contentsOf: url) {
            let decoder = PropertyListDecoder()
            styleDictionary = try? decoder.decode(StyleDictionary.self, from: data)
        }
    }

    public func font(forTextStyle textStyle: UIFont.TextStyle) -> UIFont {
        guard let fontDescription = styleDictionary?[textStyle.rawValue],
            let font = UIFont(name: fontDescription.fontName, size: fontDescription.fontSize) else {
                return UIFont.preferredFont(forTextStyle: textStyle)
        }
        
        let fontMetrics = UIFontMetrics(forTextStyle: textStyle)
        return fontMetrics.scaledFont(for: font)
    }
}

//extension Font {
//    enum Use {
//        case articleListArticleDate
//        case articleListArticleTitle
//
//        var font: UIFont {
//            switch self {
//            case .articleListArticleDate:
//                return UIFont.TextStyle.subheadline.scaledCustomFont
//            case .articleListArticleTitle:
//                return UIFontMetrics.title1.scaledFont(for: Font.provider.black)
//            }
//        }
//}
//
//        private func font(withTextStyle textStyle: UIFont.TextStyle = .body, weight: UIFont.Weight = .regular) -> UIFont {
//            let descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: textStyle)
//            let name = fontName(for: weight)
//            guard
//                let font = UIFont(name: name, size: descriptor.pointSize)
//                else { fatalError("Failed to load font") }
//            return font
//        }
//
//        private func fontName(for weight: UIFont.Weight) -> String {
//            switch weight {
//            case .ultraLight:
//                return "SourceSansPro-ExtraLight"
//            case .thin:
//                return "SourceSansPro-Light"
//            case .light:
//                return "SourceSansPro-Light"
//            case .regular:
//                return "SourceSansPro-Regular"
//            case .medium:
//                return "SourceSansPro-SemiBold"
//            case .semibold:
//                return "SourceSansPro-SemiBold"
//            case .bold:
//                return "SourceSansPro-Bold"
//            case .heavy:
//                return "SourceSansPro-Bold"
//            case .black:
//                return "SourceSansPro-Black"
//            default:
//                return "SourceSansPro-Regular"
//            }
//        }
//    }
//}
//
//extension UIFontMetrics {
//    public static let largeTitle: UIFontMetrics = UIFontMetrics(forTextStyle: .largeTitle)
//    public static let title1: UIFontMetrics = UIFontMetrics(forTextStyle: .title1)
//    public static let title2: UIFontMetrics = UIFontMetrics(forTextStyle: .title2)
//    public static let title3: UIFontMetrics = UIFontMetrics(forTextStyle: .title3)
//    public static let headline: UIFontMetrics = UIFontMetrics(forTextStyle: .headline)
//    public static let subheadline: UIFontMetrics = UIFontMetrics(forTextStyle: .subheadline)
//    public static let body: UIFontMetrics = UIFontMetrics(forTextStyle: .body)
//    public static let callout: UIFontMetrics = UIFontMetrics(forTextStyle: .callout)
//    public static let footnote: UIFontMetrics = UIFontMetrics(forTextStyle: .footnote)
//    public static let caption1: UIFontMetrics = UIFontMetrics(forTextStyle: .caption1)
//    public static let caption2: UIFontMetrics = UIFontMetrics(forTextStyle: .caption2)
//}
