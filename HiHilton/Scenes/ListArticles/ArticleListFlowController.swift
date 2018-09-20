//
//  ArticleListFlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//
import FirebaseAnalytics

protocol ArticleFlowControllerCommands {
    func endLoading()
    func update(with articles: [Article])
}

class ArticleListFlowController: FlowController {
    var model: ArticleListModel?
    
    override func start() {
        navController?.setViewControllers([self], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Hilton"
        display(LoadingViewController())
        getListOfArticles()
    }
}

extension ArticleListFlowController {
    private func getListOfArticles() {
        model = ArticleListModel()
        model?.getArticles { [weak self] (articles, error) in
            if let error = error {
                self?.displayErrorAlert(for: error)
                return
            }
            self?.displayArticleList(with: articles)
        }
    }
    
    private func displayErrorAlert(for error: Error) {
        let errorAlert = UIAlertController(title: "Error retrieving articles", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    
    private func displayArticleList(with articles: [Article]) {
        reportEventDidViewArticleList()
        let articleListVM = ArticleListViewModel(with: articles)
        let articleListVC = ArticleListViewController(with: articleListVM, delegate: self)
        transition(to: articleListVC)
    }
}

extension ArticleListFlowController: ArticleSelectionDelegate {
    func didPullToRefreshArticleList(viewController controller: ArticleListViewController) {
        model?.updateArticles() { [weak self] (articles, error) in
            controller.endLoading()
            if let error = error {
                self?.displayErrorAlert(for: error)
            }
            controller.update(with: articles)
        }
    }
    
    func articleList(viewController controller: ArticleListViewController, didSelectArticle article: Article) {
        reportEventDidSelect(article: article)
        let singleArticleFlow = SingleArticleFlowController(with: navController)
        singleArticleFlow.delegate = self
        add(childFlow: singleArticleFlow)
        singleArticleFlow.start(with: article)
    }
}

extension ArticleListFlowController: SingleArticleFlow {
    func returningFrom(flowController: SingleArticleFlowController) {
        remove(childFlow: flowController)
    } 
}

// Analytics
extension ArticleListFlowController {
    private func reportEventDidSelect(article: Article) {
        Analytics.logEvent(AnalyticsEventSelectContent, parameters: [
            AnalyticsParameterItemID: "id-\(article.id)",
            AnalyticsParameterItemName: article.title,
            AnalyticsParameterContentType: "article"
            ])
    }
    
    private func reportEventDidViewArticleList() {
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemCategory: "article"
            ])
    }
}
