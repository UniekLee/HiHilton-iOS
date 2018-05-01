//
//  ViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import Alamofire

class ListArticlesViewController: UITableViewController {
    var viewModel: ListArticlesViewModel
    
    required init?(coder aDecoder: NSCoder) {
        viewModel = ListArticlesViewModel()
        super.init(coder: aDecoder)
        viewModel.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
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
}

extension ListArticlesViewController: ListArticlesViewModelProtocol {
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

