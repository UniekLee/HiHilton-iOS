//
//  ArticleListViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import Alamofire

protocol ArticleSelectionDelegate: class {
    func didPullToRefreshArticleList(viewController controller: ArticleListViewController)
    func articleList(viewController controller: ArticleListViewController, didSelectArticle article: Article)
}

class ArticleListViewController: UITableViewController {
    private var viewModel: ArticleListViewModel
    private weak var delegate: ArticleSelectionDelegate?
    
    init(with viewModel: ArticleListViewModel, delegate: ArticleSelectionDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(style: .plain)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Use another initializer")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
    }
    
    func setUpTableView() {
        setUpRefreshController()
        tableView.prefetchDataSource = self
        tableView.register(ArticleTableViewCell.nib, forCellReuseIdentifier: "articleCell")
    }
    
    func setUpRefreshController() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(pulledToRefresh(_:)), for: .valueChanged)
        self.refreshControl = refreshControl
    }
    
    @IBAction func pulledToRefresh(_ sender: UIRefreshControl) {
        delegate?.didPullToRefreshArticleList(viewController: self)
    }
}

// FlowControllerInputs
extension ArticleListViewController: ArticleFlowControllerCommands {
    func endLoading() {
        if refreshControl?.isRefreshing == true {
            refreshControl?.endRefreshing()
        }
    }
    
    func update(with articles: [Article]) {
        viewModel.articles = articles
        tableView.reloadData()
    }
}

// Table View Delegate & Data Source
extension ArticleListViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as? ArticleTableViewCell
            else { return UITableViewCell() }
        let article = viewModel.article(for: indexPath.row)
        cell.setContent(for: article)
        viewModel.imagePath(for: article) { [cell] (imagePath) in
            cell.setImage(for: imagePath)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = viewModel.article(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.articleList(viewController: self, didSelectArticle: selectedArticle)
    }
}

extension ArticleListViewController: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        viewModel.fetchImagePaths(for: indexPaths.map({ $0.row }))
    }
}
