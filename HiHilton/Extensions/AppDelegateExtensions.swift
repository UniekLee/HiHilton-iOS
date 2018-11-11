//
//  AppDelegateExtensions.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//
import Firebase
import FirebaseMessaging
import UserNotifications

extension AppDelegate {
    func setUpStyling() {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        UINavigationBar.appearance().barTintColor = .harcourtsWhite
        UINavigationBar.appearance().tintColor = .harcourtsNavy
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.harcourtsNavy]
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    func authenticateUser() {
        Auth.auth().signInAnonymously(completion: nil)
    }
}

// Dynamic Link Handling
extension AppDelegate {
    func application(_ application: UIApplication,
                     continue userActivity: NSUserActivity,
                     restorationHandler: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        let handled = DynamicLinks.dynamicLinks().handleUniversalLink(userActivity.webpageURL!) { [weak self] (dynamicLink, error) in
            guard let link = dynamicLink else { return }
            self?.handleDynamic(link: link)
        }
        
        return handled
    }
    
    @available(iOS 9.0, *)
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        return application(app, open: url,
                           sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
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

// Push Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    func registerForPushNotifications(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(options: authOptions, completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        Messaging.messaging().subscribe(toTopic: "new_articles")
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        guard
            let articleIdString = userInfo["gcm.notification.articleId"] as? String,
            let articleId = Int(articleIdString)
            else { return }
        appFlow?.showArticle(with: articleId)
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("[FCM]: Firebase registration token: \(fcmToken)")
        
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}
