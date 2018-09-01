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
    func articleSelected(_ newArticle: Article)
}

class ArticleListViewController: UITableViewController {
    var viewModel: ArticleListViewModel
    weak var delegate: ArticleSelectionDelegate?
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ArticleListViewModel()
        super.init(coder: aDecoder)
        viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        splitViewController?.delegate = self
    }
    
    @IBAction func pulledToRefresh(_ sender: UIRefreshControl) {
        viewModel.reload()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = self.viewModel.title(for: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedArticle = viewModel.article(for: indexPath.row)
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.articleSelected(selectedArticle)
        if let readArticleVC = delegate as? ReadArticleViewController,
            let readArticleNav = readArticleVC.navigationController {
            splitViewController?.showDetailViewController(readArticleNav, sender: nil)
        }
    }
}

extension ArticleListViewController: UISplitViewControllerDelegate {
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
}

extension ArticleListViewController: ListArticlesViewModelProtocol {
    func reloadArticlesSucceeded() {
        self.refreshControl?.endRefreshing()
        self.tableView.reloadData()
    }
    
    func reloadArticlesFailed(with error: Error) {
        self.refreshControl?.endRefreshing()
        // TODO: show error
        print(error.localizedDescription)
    }
}

