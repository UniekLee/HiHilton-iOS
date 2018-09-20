//
//  AppFlowController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import Foundation
import UIKit

class AppFlowController: FlowControllable {
    var childFlows: [FlowControllable]
    
    var window: UIWindow
    lazy var appNavController: UINavigationController = {
        let rootView = UIViewController()
        let nav = UINavigationController(rootViewController: rootView)
        return nav
    }()
    weak var navController: UINavigationController?
    
    private var started: Bool = false
    private var waitingArticleId: Int?
    
    init(with window: UIWindow) {
        self.window = window
        childFlows = []
    }
    
    func start() {
        let greetingVC = GreetingViewController(nibName: String(describing: GreetingViewController.self), bundle: HiHilton)
        window.rootViewController = greetingVC
        window.makeKeyAndVisible()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            greetingVC.completeGreeting()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [unowned self] in
            self.window.rootViewController = self.appNavController
            self.completeStart()
        }
    }
    
    private func completeStart() {
        goToArticleList()
        started = true
        if let articleId = waitingArticleId {
            showArticle(with: articleId)
        }
    }
}

extension AppFlowController {
    func goToArticleList() {
        let articleListFlow = ArticleListFlowController(with: appNavController)
        add(childFlow: articleListFlow)
        articleListFlow.start()
    }
}

// Dynamic Linking
extension AppFlowController {
    func showArticle(with articleId: Int) {
        guard started else {
            waitingArticleId = articleId
            return
        }
        let singleArticleFlow = SingleArticleFlowController(with: appNavController)
        singleArticleFlow.delegate = self
        add(childFlow: singleArticleFlow)
        singleArticleFlow.start(with: articleId)
    }
}

extension AppFlowController: SingleArticleFlow {
    func returningFrom(flowController: SingleArticleFlowController) {
        remove(childFlow: flowController)
    }
}
