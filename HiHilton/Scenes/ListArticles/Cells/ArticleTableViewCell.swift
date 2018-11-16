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
        dateLabel.text = DateFormatter.articleListDateFormater.string(from: article.date ?? Date()).uppercased()
        dateLabel.setTextStyle(as: Style.ArticleList.Article.date)
        
        titleLabel.text = article.title
        titleLabel.setTextStyle(as: Style.ArticleList.Article.title)
        
        excerptLabel.setHTML(text: article.excerpt, withAttributes: [NSAttributedString.Key.font : Font.forStyle(Style.ArticleList.Article.excerpt)])
        excerptLabel.adjustsFontForContentSizeCategory = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        featuredImage.image = nil
        titleLabel.text = nil
        dateLabel.text = nil
        excerptLabel.text = nil
    }
}
