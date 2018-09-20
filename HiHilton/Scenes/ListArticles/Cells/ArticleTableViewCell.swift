//
//  ArticleTableViewCell.swift
//  HiHilton
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
        guard
            let imagePath = path,
            let imageURL = URL(string: imagePath)
            else {
                featuredImage.isHidden = true
            return
        }
        featuredImage.isHidden = false
        featuredImage.setImage(url: imageURL)
    }
    
    func populateContent() {
        guard let article = article else { return }
        titleLabel.text = article.title
        dateLabel.text = DateFormatter.articleListDateFormater.string(from: article.date)
        excerptLabel.setHTML(text: article.excerpt, withAttributes: [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15, weight: .light)])
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featuredImage.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        excerptLabel.text = nil
    }
}
