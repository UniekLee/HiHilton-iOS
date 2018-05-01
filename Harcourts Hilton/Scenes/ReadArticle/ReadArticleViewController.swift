//
//  ReadArticleViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/05/01.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import Kingfisher

class ReadArticleViewController: UIViewController {
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleGallery: UICollectionView!
    
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
        articleTitle.text = article?.title
        if let content = article?.content {
            articleContent.attributedText = NSAttributedString(string: content, attributes: [kCTParagraphStyleAttributeName as NSAttributedStringKey : contentStyle])
        }
        articleGallery.reloadData()
    }

}

extension ReadArticleViewController: ArticleSelectionDelegate {
    func articleSelected(_ newArticle: Article) {
        article = newArticle
    }
}

extension ReadArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let article = article else { return 0 }
        return article.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as? ReadArticleGalleryImageCollectionViewCell,
            let image = article?.images[indexPath.item],
            let imageURL = URL(string: image.thumbnail_link)
            else { return UICollectionViewCell() }
        cell.galleryImage.kf.setImage(with: imageURL)
        return cell
    }
    
}
