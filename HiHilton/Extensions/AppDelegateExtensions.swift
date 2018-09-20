//
//  AppDelegateExtensions.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/13.
//  Copyright © 2018 UniekLee. All rights reserved.
//
import FirebaseAuth

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
    
    func authenticateUser() {
        Auth.auth().signInAnonymously(completion: nil)
    }
}
