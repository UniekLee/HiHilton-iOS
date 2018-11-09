//
//  SingleArticleFlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import FirebaseAnalytics

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
    
    func start(with articleId: Int) {
        article = Article()
        article?.id = articleId
        presentSingleArticle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Article"
        display(LoadingViewController())
        getArticleDetails()
    }
    
    override func willMove(toParent parent: UIViewController?) {
        super.willMove(toParent: parent)
        if parent == nil {
            delegate?.returningFrom(flowController: self)
        }
    }
}

extension SingleArticleFlowController {
    private func presentSingleArticle() {
        let modalNav = UINavigationController(rootViewController: self)
        let closeButton = UIBarButtonItem(barButtonSystemItem: .done,
                                          target: self,
                                          action: #selector(SingleArticleFlowController.modalDoneTapped(_:)))
        navigationItem.setLeftBarButton(closeButton, animated: true)
        navController?.present(modalNav, animated: true, completion: nil)
    }
    
    @objc func modalDoneTapped(_ button: UIBarButtonItem) {
        navController?.dismiss(animated: true, completion: nil)
    }
}

extension SingleArticleFlowController {
    func getArticleDetails() {
        guard let article = article else { return }
        
        if article.fetched {
            getMedia(for: article.id)
        } else {
            getArticle(with: article.id)
        }
    }
    
    private func getMedia(for articleId: Int) {
        ArticleMediaModel.getMedia(for: articleId) { [weak self] (media, error) in
            guard let article = self?.article else { return }
            self?.reportEventDidView(article: article)
            let singleArticleVC = SingleArticleViewController(with: article, media: media)
            self?.transition(to: singleArticleVC)
        }
    }
    
    private func getArticle(with articleId: Int) {
        SingleArticleModel.getArticle(with: articleId) { [weak self, articleId] (possibleArticle, possibleError) in
            guard let article = possibleArticle else {
                debugPrint(possibleError!.localizedDescription)
                return
            }
            self?.article = article
            self?.getMedia(for: articleId)
        }
    }
}

// Analytics
extension SingleArticleFlowController {
    private func reportEventDidView(article: Article) {
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemID: "id-\(article.id)",
            AnalyticsParameterItemName: article.title ?? "",
            AnalyticsParameterContentType: "article"
            ])
    }
}
