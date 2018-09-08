//
//  SingleArticleViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/05/01.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import Kingfisher
import TTTAttributedLabel

class SingleArticleViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    @IBOutlet weak var galleryContainerView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var article: Article? {
        didSet {
            reloadView()
        }
    }
    
    lazy var contentStyle: NSParagraphStyle = {
       let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(2)
        return style.copy() as! NSParagraphStyle
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadView() {
        loadViewIfNeeded()
        titleLabel.text = article?.title
        if let content = article?.content {
            contentLabel.htmlText = content
        }
        galleryCollectionView.reloadData()
        galleryContainerView.isHidden = true //article?.links.wpAttachment.images.count == 0
    }
}

extension TTTAttributedLabel {
    var htmlText: String {
        set {
            let attributedString = newValue.attributedStringFromHTML
            attributedText = attributedString
        }
        get {
            return attributedText.htmlString
        }
    }
}

extension String {
    var attributedStringFromHTML: NSAttributedString {
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data,
                                          options: [.documentType: NSAttributedString.DocumentType.html,
                                                    .characterEncoding : String.Encoding.utf8.rawValue],
                                          documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
}

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
}

extension SingleArticleViewController: ArticleSelectionDelegate {
    func articleSelected(_ newArticle: Article) {
        article = newArticle
    }
}

extension SingleArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let article = article else { return 0 }
        return 0 // article.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
//        guard
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? SingleArticleGalleryImageCollectionViewCell,
//            let image = article?.images[indexPath.item],
//            let imageURL = URL(string: image.thumbnail_link)
//            else { return UICollectionViewCell() }
//        cell.imageView.kf.setImage(with: imageURL)
//        return cell
    }
    
}
