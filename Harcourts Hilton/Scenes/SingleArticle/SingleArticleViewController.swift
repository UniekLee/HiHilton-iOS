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
    
    var article: Article
    var media: [Media]
    
    lazy var contentStyle: NSParagraphStyle = {
       let style = NSMutableParagraphStyle()
        style.lineSpacing = CGFloat(2)
        return style.copy() as! NSParagraphStyle
    }()
    
    init(with article: Article, media: [Media] = []) {
        self.article = article
        self.media = media
        super.init(nibName: String(describing: SingleArticleViewController.self), bundle: HarcourtsHilton)
    }
    
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.register(SingleArticleGalleryImageCollectionViewCell.nib, forCellWithReuseIdentifier: "thumbnailCell")
        updateViewContent()
    }
    
    func updateViewContent() {
        loadViewIfNeeded()
        titleLabel.text = article.title
        contentLabel.htmlText = article.content
        galleryCollectionView.reloadData()
        galleryContainerView.isHidden = media.count == 0
    }
}

extension SingleArticleViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let mediaItem = media[indexPath.item]
        guard
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCell", for: indexPath) as? SingleArticleGalleryImageCollectionViewCell,
            let mediaURL = URL(string: mediaItem.thumbnailPath)
            else { return UICollectionViewCell() }
        cell.imageView.kf.setImage(with: mediaURL)
        return cell
    }
    
}
