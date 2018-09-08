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
