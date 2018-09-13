//
//  GreetingViewController.swift
//  Harcourts Hilton
//
//  Created by Lee Watkins on 2018/09/08.
//  Copyright © 2018 UniekLee. All rights reserved.
//

class GreetingViewController: UIViewController {

    @IBOutlet weak var greetingView: UIView!
    @IBOutlet weak var nameView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameView.isHidden = true
    }
    
    func completeGreeting() {
        UIView.animate(withDuration: 0.5) { [unowned self] in
            self.nameView.isHidden = false
        }
    }
}
