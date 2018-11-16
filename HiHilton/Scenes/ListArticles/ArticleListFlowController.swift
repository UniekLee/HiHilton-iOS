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
    private let searchController = UISearchController(searchResultsController: nil)
    private var articleListVC: ArticleListViewController?
    
    override func start() {
        navController?.setViewControllers([self], animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "ARTICLES"
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.hidesSearchBarWhenScrolling = true
        getListOfArticles()
    }
}

extension ArticleListFlowController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
}

// Search
extension ArticleListFlowController {
    func setUpSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Articles"
        searchController.searchBar.tintColor = .harcourtsNavy
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
}

extension ArticleListFlowController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchString = searchController.searchBar.text else { return }
        articleListVC?.filterArticles(using: searchString)
    }
}

extension ArticleListFlowController {
    private func getListOfArticles() {
        model = ArticleListModel()
        transition(to: LoadingViewController())
        model?.getArticles { [weak self] (articles, error) in
            if error != nil && articles.count == 0 {
                let errorVC = ErrorViewController(nibName: nil, bundle: nil)
                errorVC.tryAgainHandler = {
                    self?.getListOfArticles()
                }
                self?.transition(to: errorVC)
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
        setUpSearchController()
        let articleListVM = ArticleListViewModel(with: articles)
        articleListVC = ArticleListViewController(with: articleListVM, delegate: self)
        if let controller = articleListVC {
            transition(to: controller)
        }
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
            AnalyticsParameterItemName: article.title ?? "",
            AnalyticsParameterContentType: "article"
            ])
    }
    
    private func reportEventDidViewArticleList() {
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [
            AnalyticsParameterItemCategory: "article"
            ])
    }
}
