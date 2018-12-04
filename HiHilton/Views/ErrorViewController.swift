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
    
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var errorDetailsLabel: UILabel!
    var tryAgainHandler: RetryHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        errorDetailsLabel.setTextStyle(as: Style.ErrorScreen.errorDetails)
        tryAgainButton.setTextStyle(as: Style.ErrorScreen.tryAgainButton)
    }
    
    @IBAction func tryAgainTapped(_ sender: UIButton) {
        tryAgainHandler?()
    }
}
