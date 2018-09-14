//
//  ArticleTableViewCell.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class ArticleTableViewCell: UITableViewCell {

    @IBOutlet weak var featuredImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var excerptLabel: TTTAttributedLabel!
    
    private var article: Article?
    
    func setContent(for article: Article) {
        self.article = article
        populateContent()
    }
    
    func setImage(for path: String?) {
        guard let imagePath = path, let imageURL = URL(string: imagePath) else { return }
        featuredImage.setImage(url: imageURL)
    }
    
    func populateContent() {
        titleLabel.text = article?.title
        dateLabel.text = article?.date
        excerptLabel.htmlText = article?.excerpt

//        if imageId == 0 {
//            hide the image view
//        }
//        if let imageId = article?.featuredImage?.id {
//            featuredImage.setWordPressMedia(id: imageId)
//        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featuredImage.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        excerptLabel.text = nil
    }
}
