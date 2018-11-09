//
//  SingleArticleViewController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/05/01.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import TTTAttributedLabel
import Lightbox
import Imaginary
import FirebaseAnalytics

class SingleArticleViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: TTTAttributedLabel!
    @IBOutlet weak var galleryContainerView: UIView!
    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    var article: Article
    var media: [Media]
    
    init(with article: Article, media: [Media] = []) {
        self.article = article
        self.media = media
        super.init(nibName: String(describing: SingleArticleViewController.self), bundle: HiHilton)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        galleryCollectionView.register(SingleArticleGalleryImageCollectionViewCell.nib, forCellWithReuseIdentifier: "thumbnailCell")
        updateViewContent()
        LightboxConfig.PageIndicator.separatorColor = .clear
        LightboxConfig.PageIndicator.textAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
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
        cell.imageView.setImage(url: mediaURL)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        reportEventDidSelect(media: media[indexPath.item])
        let controller = LightboxController(images: lightboxImages, startIndex: indexPath.item)
        controller.dynamicBackground = true
        controller.pageDelegate = self
        present(controller, animated: true, completion: nil)
    }
}

extension SingleArticleViewController {
    var lightboxImages: [LightboxImage] {
        return media.map({ (media) -> LightboxImage in
            LightboxImage(imageURL: URL(string: media.fullPath)!, text: media.caption, videoURL: nil)
        })
    }
}

extension SingleArticleViewController: LightboxControllerPageDelegate {
    func lightboxController(_ controller: LightboxController, didMoveToPage page: Int) {
        reportEventDidView(media: media[page])
    }
}

// Analytics
extension SingleArticleViewController {
    private func reportEventDidSelect(media: Media) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(media.id)",
            AnalyticsParameterItemName: media.title,
            AnalyticsParameterContentType: "media"
            ])
    }
    
    private func reportEventDidView(media: Media) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(media.id)",
            AnalyticsParameterItemName: media.title,
            AnalyticsParameterContentType: "media"
            ])
    }
}
