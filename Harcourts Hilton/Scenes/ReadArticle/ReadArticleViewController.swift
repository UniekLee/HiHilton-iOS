//
//  ReadArticleViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/05/01.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit

class ReadArticleViewController: UIViewController {
    @IBOutlet weak var articleTitle: UILabel!
    @IBOutlet weak var articleContent: UILabel!
    @IBOutlet weak var articleGallery: UICollectionView!
    
    var article: Article? {
        didSet {
            reloadView()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func reloadView() {
        loadViewIfNeeded()
        articleTitle.text = article?.title
        articleContent.text = article?.content
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath)
        return cell
    }
    
}
