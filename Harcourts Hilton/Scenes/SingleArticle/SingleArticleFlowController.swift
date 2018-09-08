//
//  SingleArticleFlowController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

protocol SingleArticleFlow: AnyObject {
    func returningFrom(flowController: SingleArticleFlowController)
}

class SingleArticleFlowController: FlowController {
    var article: Article?
    weak var delegate: SingleArticleFlow?
    
    func start(with article: Article) {
        self.article = article
        navController?.show(self, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article"
        display(LoadingViewController())
        getArticleDetails()
    }
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        if parent == nil {
            delegate?.returningFrom(flowController: self)
        }
    }
}

extension SingleArticleFlowController {
    func getArticleDetails() {
        guard let articleId = article?.id else { return }
        ArticleMediaModel.getMedia(for: articleId) { [weak self] (media, error) in
            guard let article = self?.article else { return }
            let singleArticleVC = SingleArticleViewController(with: article, media: media)
            self?.transition(to: singleArticleVC)
        }
    }
}
