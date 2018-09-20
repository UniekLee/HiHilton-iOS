//
//  AppDelegate.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/04/30.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDynamicLinks

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var navController: UINavigationController?
    var appFlow: AppFlowController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        authenticateUser()
        setUpStyling()
        UIApplication.shared.isStatusBarHidden = false
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = .white
        guard let window = window else { return false }
        appFlow = AppFlowController(with: window)
        appFlow?.start()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        Analytics.logEvent(AnalyticsEventAppOpen, parameters: nil)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamicLink, error) in
            guard let link = dynamicLink else { return }
            self?.handleDynamic(link: link)
        }
        
        return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplicationOpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url,
                           sourceApplication: options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                           annotation: "")
    }
    
    func application(_ application: UIApplication,
                     open url: URL,
                     sourceApplication: String?,
                     annotation: Any) -> Bool {
        if let dynamicLink = DynamicLinks.dynamicLinks().dynamicLink(fromCustomSchemeURL: url) {
            handleDynamic(link: dynamicLink)
            return true
        }
        return false
    }
    
    func handleDynamic(link: DynamicLink) {
        if let url = link.url {
            let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
            if components?.host == "hilton.swiftetc.com" {
                guard
                    let postType = components?.queryItems?.filter({ $0.name == "post_type"}).first?.value,
                    postType == "articles",
                    let articleIdString = components?.queryItems?.filter({ $0.name == "p"}).first?.value,
                    let articleId = Int(articleIdString)
                    else { return }
                appFlow?.showArticle(with: articleId)
            }
        }
    }
}

