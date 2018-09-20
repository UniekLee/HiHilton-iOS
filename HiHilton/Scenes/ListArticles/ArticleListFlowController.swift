//
//  ArticleListFlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

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
    func getListOfArticles() {
        model = ArticleListModel()
        model?.getArticles { [weak self] (articles, error) in
            if let error = error {
                self?.displayErrorAlert(for: error)
                return
            }
            self?.displayArticleList(with: articles)
        }
    }
    
    func displayErrorAlert(for error: Error) {
        let errorAlert = UIAlertController(title: "Error retrieving articles", message: error.localizedDescription, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        errorAlert.addAction(okAction)
        present(errorAlert, animated: true, completion: nil)
    }
    
    func displayArticleList(with articles: [Article]) {
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
