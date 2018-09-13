//
//  AppDelegateExtensions.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//

extension AppDelegate {
    func setUpStyling() {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar() {
        UINavigationBar.appearance().barTintColor = .harcourtsNavy
        UINavigationBar.appearance().tintColor = .harcourtsWhite
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor.harcourtsWhite]
        UIApplication.shared.statusBarStyle = .lightContent
    }
}
