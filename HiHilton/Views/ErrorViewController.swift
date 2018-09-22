//
//  ErrorViewController.swift
//  HiHilton
//
//  Created by Lee Watkins on 2018/09/22.
//  Copyright © 2018 UniekLee. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    typealias RetryHandler = () -> Void
    
    var tryAgainHandler: RetryHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        tryAgainHandler?()
    }
}
