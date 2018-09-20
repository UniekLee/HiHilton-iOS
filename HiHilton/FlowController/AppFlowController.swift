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
            self.goToArticleList()
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
